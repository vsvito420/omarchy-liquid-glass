const HOST = "com.omarchy.sepia_web";
const SEPIA_THEMES = new Set(["liquid-glass-warm"]);
const FALLBACK_COLOR = "#ece0c8";

let lastRefresh = 0;

async function refresh() {
  const now = Date.now();
  if (now - lastRefresh < 1000) return;
  lastRefresh = now;

  let reply;
  try {
    reply = await chrome.runtime.sendNativeMessage(HOST, {});
  } catch (e) {
    console.warn("Omarchy Sepia Web: native host unavailable —", e.message);
    return;
  }

  const color = /^#[0-9a-f]{6}$/i.test(reply?.background ?? "")
    ? reply.background.toLowerCase()
    : FALLBACK_COLOR;
  const next = { enabled: SEPIA_THEMES.has(reply?.theme), color };

  const { state } = await chrome.storage.local.get("state");
  if (state?.enabled !== next.enabled || state?.color !== next.color) {
    await chrome.storage.local.set({ state: next });
  }
}

function ensureAlarm() {
  chrome.alarms.create("poll", { periodInMinutes: 0.5 });
}

chrome.runtime.onInstalled.addListener(() => { ensureAlarm(); refresh(); });
chrome.runtime.onStartup.addListener(() => { ensureAlarm(); refresh(); });
chrome.alarms.onAlarm.addListener(refresh);
chrome.tabs.onActivated.addListener(refresh);
chrome.windows.onFocusChanged.addListener((id) => {
  if (id !== chrome.windows.WINDOW_ID_NONE) refresh();
});
