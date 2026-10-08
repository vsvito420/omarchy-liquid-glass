# Liquid Glass for Omarchy

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" width="72" height="72" role="img" aria-label="Icon Liquid Glass">
  <defs><linearGradient id="lgbg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#5b8def"/><stop offset=".55" stop-color="#9b6cf0"/><stop offset="1" stop-color="#f08ab8"/></linearGradient></defs>
  <rect width="128" height="128" rx="28" fill="url(#lgbg)"/>
  <rect x="24" y="30" width="80" height="68" rx="20" fill="#fff" fill-opacity=".28" stroke="#fff" stroke-opacity=".85" stroke-width="3"/>
  <path d="M36 44 Q48 36 64 38" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round"/>
</svg>

Ein Theme für Omarchy im Liquid-Glass-Look: Milchglas-Unschärfe, abgerundete Fenster und federnde Animationen.
Dazu ein optionaler Bildschirmschoner und eine Browser-Erweiterung für die Sepia-Variante.

![Hintergründe der dunklen Variante](https://raw.githubusercontent.com/vsvito420/omarchy-liquid-glass/main/screenshots/dark-wallpapers.jpg)

## Was es zeigt

- **Varianten** – Liquid Glass Dark, Light und Warm (sanftes Sepia, schont die Augen)
- **Fenster** – abgerundete Squircles mit dünnem Glasrand und weichem Schatten
- **Unschärfe** hinter Fenstern, Bar, Menüs, Benachrichtigungen und OSD
- **Terminals** durchscheinend, Text bleibt scharf (foot, Alacritty, kitty, Ghostty)
- **Animationen** federnd wie bei iOS
- **Farben** – Apple-Systempalette, im Hellmodus kontrastreich; Chromium-Leiste passend eingefärbt
- **Hintergründe** – eigene Verläufe für jede Variante, plus Synthwave-Hintergrund im Dunkelmodus

![Hintergründe der hellen Variante](https://raw.githubusercontent.com/vsvito420/omarchy-liquid-glass/main/screenshots/light-wallpapers.jpg)

## Installieren

```bash
git clone https://github.com/vsvito420/omarchy-liquid-glass.git
cd omarchy-liquid-glass
./install.sh
omarchy theme set "Liquid Glass Dark"   # oder "Liquid Glass Light" / "Liquid Glass Warm"
```

Danach ein neues Terminal öffnen, damit der durchscheinende Hintergrund greift.

<div class="callout warning" markdown="1">
**Warum nicht `omarchy theme install <url>`?** Omarchy entfernt bei Git-Themes aus Sicherheitsgründen `hyprland.lua`
und die Terminal-Configs – genau da stecken Unschärfe, Rundung und Transparenz. `install.sh` kopiert die Themes deshalb.
`hyprland.lua` wird von Hyprland ausgeführt, also vorher reinschauen.
</div>

## Bildschirmschoner

- **Nachtfahrt** durch eine Glaslandschaft: nasse Glasstraße, Milchglas-Berge mit Parallaxe, Regentropfen auf der Scheibe
- **Pixel-Uhr** mit Sekunden auf einer Glaskarte, dazu leichte CRT-Scanlines
- **Himmel** folgt der Tageszeit – Sonnenaufgang, Mittag, Synthwave-Sonnenuntergang, Mond und Sterne
- **Stile** in `~/.config/liquid-glass/screensaver.toml`
  - `retro` (Standard) – stilisierter Tag nach der Uhrzeit
  - `sun` – echter Sonnen- und Mondstand für einen Ort (z. B. Berlin, `52.52` / `13.40`), bleibt lokal, nichts wird online abgefragt
- läuft nur mit einem Liquid-Glass-Theme, sonst der normale Omarchy-Bildschirmschoner

![Bildschirmschoner im Tagesverlauf](https://raw.githubusercontent.com/vsvito420/omarchy-liquid-glass/main/screenshots/screensaver-day-cycle.jpg)

```bash
./screensaver/install.sh           # installieren / aktualisieren (fragt einmal nach sudo)
./screensaver/install.sh --remove  # zurück zum Omarchy-Bildschirmschoner
omarchy launch screensaver force   # sofort ausprobieren
```

## So funktioniert's

- **Code:** [`themes/`](https://github.com/vsvito420/omarchy-liquid-glass/tree/main/themes) – pro Variante `hyprland.lua`, `shell.toml`, `colors.toml` und Terminal-Configs
- **Bildschirmschoner:** reines Python 3.11+, keine Pakete
  - ein kleiner `ttfx`-Shim in `/usr/local/bin` startet ihn statt des Zufallseffekts, alle anderen Aufrufe gehen an `/usr/bin/ttfx` weiter
  - schickt nur geänderte Terminal-Zellen – ca. 13 % eines Kerns bei 20 fps
- **Sepia-Webseiten:** Erweiterung für Chromium / Chrome in `sepia-web/`
  - färbt weiße Seiten im Ton der Warm-Variante, Bilder und dunkle Seiten bleiben
  - ein kleiner Native-Messaging-Host meldet das aktive Theme, aktiv nur bei **Liquid Glass Warm**
- **Anpassen:** Unschärfe, Rundung, Animationen in `hyprland.lua`, Bar-Transparenz in `shell.toml`, Farben in `colors.toml`
- ist Milchglas – echte Lichtbrechung kann Hyprland nicht

## Siehe auch

- [[Omarchy]]
- [[Last Round]], [[Fix my Scaling]]
