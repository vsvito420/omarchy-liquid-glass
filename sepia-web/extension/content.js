(() => {
  const ATTR = "data-omarchy-sepia";
  const MIN_CHANNEL = 235;
  const MAX_TINT = 12;
  const SKIP = new Set(["SCRIPT", "STYLE", "LINK", "META", "HEAD", "TITLE", "NOSCRIPT", "BR", "IMG", "VIDEO", "CANVAS", "SOURCE", "TEMPLATE"]);
  const isTop = window === window.top;

  let enabled = false;
  let base = [236, 224, 200];
  const rules = new Map();
  const sheet = new CSSStyleSheet();
  const earlySheet = new CSSStyleSheet();
  let observer = null;
  const pending = new Set();
  let pendingFull = false;
  let scheduled = false;

  function parseHex(hex) {
    const n = parseInt(hex.slice(1), 16);
    return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
  }

  function parseRgb(s) {
    const m = /^rgba?\(([^)]+)\)$/.exec(s);
    if (!m) return null;
    const p = m[1].split(/[\s,/]+/).filter(Boolean).map(Number);
    return { r: p[0], g: p[1], b: p[2], a: p.length > 3 ? p[3] : 1 };
  }

  function ruleText(key, v, a) {
    const [r, g, b] = base.map((c) => Math.round((c * v) / 255));
    return `[${ATTR}="${key}"]{background-color:rgba(${r},${g},${b},${a / 100})!important}`;
  }

  function keyFor(c) {
    const v = Math.round((c.r + c.g + c.b) / 3);
    const a = Math.round(c.a * 100);
    const key = `${v}-${a}`;
    if (!rules.has(key)) {
      rules.set(key, { v, a });
      sheet.insertRule(ruleText(key, v, a), sheet.cssRules.length);
    }
    return key;
  }

  function rebuildRules() {
    sheet.replaceSync([...rules].map(([k, { v, a }]) => ruleText(k, v, a)).join("\n"));
    const [r, g, b] = base;
    earlySheet.replaceSync(`html{background-color:rgb(${r},${g},${b})}`);
  }

  function attachSheets(...sheets) {
    const current = document.adoptedStyleSheets.filter((s) => !sheets.includes(s));
    document.adoptedStyleSheets = [...current, ...sheets];
  }

  function detachSheets(...sheets) {
    document.adoptedStyleSheets = document.adoptedStyleSheets.filter((s) => !sheets.includes(s));
  }

  function isWhitish(c) {
    const lo = Math.min(c.r, c.g, c.b);
    const hi = Math.max(c.r, c.g, c.b);
    return c.a > 0 && lo >= MIN_CHANNEL && hi - lo <= MAX_TINT;
  }

  function effectiveColor(el) {
    const cs = getComputedStyle(el);
    if (cs.backgroundImage.includes("gradient")) return null;
    const c = parseRgb(cs.backgroundColor);
    if (!c) return null;
    if (c.a === 0 && isTop && el === document.documentElement) {
      const body = document.body && parseRgb(getComputedStyle(document.body).backgroundColor);
      if (!body || body.a === 0) return { r: 255, g: 255, b: 255, a: 1 };
    }
    return c;
  }

  // Unmark first, then read everything, then write: keeps style recalcs batched
  // and lets us see the page's own colors rather than our overrides.
  function processRoots(roots) {
    const els = [];
    for (const root of roots) {
      if (!root.isConnected) continue;
      els.push(root, ...root.querySelectorAll("*"));
    }
    for (const el of els) el.removeAttribute(ATTR);
    const marks = [];
    for (const el of els) {
      if (SKIP.has(el.tagName)) continue;
      const c = effectiveColor(el);
      if (c && isWhitish(c)) marks.push([el, keyFor(c)]);
    }
    for (const [el, key] of marks) el.setAttribute(ATTR, key);
  }

  function flush() {
    scheduled = false;
    if (!enabled) return;
    let roots;
    if (pendingFull) {
      roots = [document.documentElement];
    } else {
      roots = [...pending].filter((el) => {
        for (let p = el.parentElement; p; p = p.parentElement) if (pending.has(p)) return false;
        return true;
      });
    }
    pending.clear();
    pendingFull = false;
    processRoots(roots);
  }

  function schedule(el) {
    if (el === document.documentElement || el === document.body) pendingFull = true;
    else pending.add(el);
    if (!scheduled) {
      scheduled = true;
      requestAnimationFrame(flush);
    }
  }

  function onMutations(list) {
    for (const m of list) {
      if (m.type === "attributes") schedule(m.target);
      else for (const n of m.addedNodes) if (n.nodeType === 1) schedule(n);
    }
  }

  function startWhenReady() {
    const run = () => {
      if (!enabled) return;
      detachSheets(earlySheet);
      processRoots([document.documentElement]);
      observer ??= new MutationObserver(onMutations);
      observer.observe(document.documentElement, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ["class"],
      });
    };
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", run, { once: true });
    } else {
      run();
    }
  }

  function enable(color) {
    base = parseHex(color);
    rebuildRules();
    if (enabled) return;
    enabled = true;
    attachSheets(sheet);
    if (isTop && document.readyState === "loading") attachSheets(earlySheet);
    startWhenReady();
  }

  function disable() {
    if (!enabled) return;
    enabled = false;
    observer?.disconnect();
    observer = null;
    pending.clear();
    detachSheets(sheet, earlySheet);
    for (const el of document.querySelectorAll(`[${ATTR}]`)) el.removeAttribute(ATTR);
  }

  function apply(state) {
    if (state?.enabled) enable(state.color);
    else disable();
  }

  chrome.storage.local.get("state").then(({ state }) => apply(state));
  chrome.storage.onChanged.addListener((changes, area) => {
    if (area === "local" && changes.state) apply(changes.state.newValue);
  });
})();
