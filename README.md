# Liquid Glass for Omarchy

A macOS / iOS-inspired "liquid glass" theme for [Omarchy](https://omarchy.org), in **dark** and **light**.

- Rounded squircle windows with a thin light glass rim and soft shadows
- Frosted blur behind windows, the bar, menus, notifications and the OSD
- Translucent terminal backgrounds with crisp text (foot, Alacritty, kitty, Ghostty)
- Springy, iOS-like window and workspace animations
- Apple system color palette (accessible high-contrast variants in light mode)
- Original gradient wallpapers for both variants, plus a synthwave Omarchy wallpaper in dark
- Optional retro synthwave screensaver with a live 24h sky, seen through liquid glass

![Dark wallpapers](screenshots/dark-wallpapers.jpg)
![Light wallpapers](screenshots/light-wallpapers.jpg)

## Install

```bash
git clone https://github.com/vsvito420/omarchy-liquid-glass.git
cd omarchy-liquid-glass
./install.sh
omarchy theme set "Liquid Glass Dark"   # or "Liquid Glass Light"
```

> **Why not `omarchy theme install <url>`?** For safety, Omarchy strips `hyprland.lua`
> and terminal configs from themes installed as git clones. That is exactly where the
> blur, rounding and transparency live, so `install.sh` copies the themes instead.
> Read the files before installing — `hyprland.lua` is executed by Hyprland.

Open a new terminal window after applying to see the translucent background.

## Screensaver

A retro synthwave screensaver seen through liquid glass: striped sun behind neon
mountains, a perspective grid rolling toward you, glass droplets that refract the
scene, and a chunky pixel clock with seconds and a sweeping seconds bar on a frosted
glass card, finished with CRT scanlines.

The sky follows the real time of day — sunrise, blue noon, synthwave sunset, then
moon and stars at night. Accent colors come from the active theme; the light variant
gets a pastel take on the same day.

![Screensaver through the day](screenshots/screensaver-day-cycle.jpg)

`install.sh` offers to install it. It runs only while a `liquid-glass-*` theme is
applied; with any other theme Omarchy's stock screensaver runs as usual.

How it hooks in: Omarchy's screensaver draws with `ttfx`, and `/usr/local/bin` comes
before `/usr/bin` on `PATH`. `screensaver/ttfx` is a small shim installed there that
starts `~/.local/bin/liquid-glass-screensaver` for the screensaver's random effect and
passes every other `ttfx` call straight through to `/usr/bin/ttfx`. Nothing in
`/usr/share/omarchy` is touched.

```bash
omarchy launch screensaver force                   # try it now
LG_SPEED=1 ~/.local/bin/liquid-glass-screensaver   # whole day as a timelapse, 1 h/s
LG_HOUR=19 ~/.local/bin/liquid-glass-screensaver   # pin the sky to 19:00
sudo rm /usr/local/bin/ttfx                        # uninstall (back to stock)
```

Plain Python 3.11+, no extra packages. Runs in foot, Alacritty, kitty and Ghostty.

## Tweaking

| What | Where |
| --- | --- |
| Blur, rounding, shadows, window opacity, animations | `themes/<variant>/hyprland.lua` |
| Bar / menu / notification translucency (`background-alpha`) | `themes/<variant>/shell.toml` |
| Terminal transparency | `alpha` in `foot.ini`, `opacity` in `alacritty.toml`, etc. |
| Colors | `themes/<variant>/colors.toml` |

`tools/glass-finish.sh` regenerates the terminal and shell files from Omarchy's templates
for the currently applied variant, e.g. `tools/glass-finish.sh dark 0.72 0.35 0.55 "#ffffff"`
(variant, terminal alpha, bar alpha, card alpha, rim color).

## Notes

This is frosted glass — Hyprland can't do real refraction / lens distortion.
Not affiliated with Apple. Wallpapers are generated with ImageMagick and are free to use.

## License

MIT
