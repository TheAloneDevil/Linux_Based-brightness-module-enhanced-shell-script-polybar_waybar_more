# Enhanced Brightness Module for Polybar

This package provides enhanced brightness modules for Linux desktop polybar.

## Files Included

1. **brightness.sh** - Main brightness script (with progress bar)
2. **brightness1.sh** - Alternative brightness script (with dot indicators)
3. **user_modules.ini** - Module configuration
4. **README.md** - This file

---

## Features

- DDC/CI support for external monitors (via ddcutil)
- System backlight fallback (via brightnessctl)
- Visual brightness indicators (icons + progress)
- Scroll to adjust brightness
- Two visual styles: bar and dots

---

## Installation

### Step 1: Install Dependencies
```bash
# Required: ddcutil (for DDC/CI monitors) and brightnessctl (for system backlight)
sudo apt install ddcutil brightnessctl
```

### Step 2: Create Directory
```bash
mkdir -p ~/your_path
```

### Step 3: Copy Files
```bash
cp brightness.sh ~/your_path/
cp brightness1.sh ~/your_path/
cp user_modules.ini ~/your_path/
```

### Step 4: Make Executable
```bash
chmod +x ~/your_path/brightness.sh
chmod +x ~/your_path/brightness1.sh
```

### Step 5: Update Paths in user_modules.ini
Open `user_modules.ini` in a text editor and edit these specific lines:

| Line | Edit This | Change To |
|------|-----------|----------|
| 5 | `exec = ~/your_path/brightness.sh get` | (keep as-is if using this path) |
| 6 | `interval = 1` | (keep) |
| 7 | `tail = true` | (keep) |
| 8 | `format = <label>` | (keep) |
| 9 | `format-prefix = "%{T1}"` | (keep) |
| 10 | `label = %output%` | (keep) |
| 11 | `scroll-up = ~/your_path/brightness.sh inc` | (adjust path if different) |
| 12 | `scroll-down = ~/your_path/brightness.sh dec` | (adjust path if different) |
| 13 | `cursor-scroll = ns-resize` | (keep) |
| 17 | `exec = ~/your_path/brightness1.sh get` | (adjust path if different) |
| 23 | `scroll-up = ~/your_path/brightness1.sh inc` | (adjust path if different) |
| 24 | `scroll-down = ~/your_path/brightness1.sh dec` | (adjust path if different) |

### Step 6: Enable Module in polybar config
Open your polybar config file (e.g., `~/.config/polybar/forest/config`):

1. Find the `[module/...]` section (around line 5-10) and add:
```ini
include-file = ~/your_path/user_modules.ini
```

2. Find your bar section (e.g., `[bar/top]`) and add `brightness-control` or `brightness1-control` to `modules-right`:
```ini
[bar/top]
modules-right = brightness1-control
```

**Note:** If you already have other modules listed, add to the existing list (e.g., `modules-right = battery_status brightness1-control`).

---

## Usage

- **brightness.sh**: Shows percentage + 10-segment bar
- **brightness1.sh**: Shows percentage + 7-dot indicator
- Scroll up on module to increase brightness
- Scroll down on module to decrease brightness

---

## Requirements

- Linux desktop with polybar
- brightnessctl (for system backlight)
- ddcutil (optional, for DDC/CI monitors)

---

## Font Reference

This module uses the following fonts (T-n = font-n+1):

| Tag | Font Number | Font Name | Size |
|-----|-------------|-----------|------|
| T1 | font-0 | Iosevka Nerd Font | 10;4 |
| T9 | font-9 | Iosevka Nerd Font | 17;5 |
| T16 | font-16 | Iosevka Nerd Font | 11;-3 |
| T19 | font-19 | Iosevka Nerd Font | 13;3 |
| T28 | font-28 | Iosevka Nerd Font | 12;4 |

**Note:** Ensure these fonts are defined in your polybar config. Add to your `config.ini`:

```ini
font-0 = "Iosevka Nerd Font:size=10;4"
font-9 = "Iosevka Nerd Font:size=17;5"
font-16 = "Iosevka Nerd Font:size=11;-3"
font-19 = "Iosevka Nerd Font:size=13;3"
font-28 = "Iosevka Nerd Font:size=12;4"
```

---

## Contribution

This is a customized version of the original brightness module. I, Anindra Mohan Trivedi, have modified it to add modern features and improvements.

I claim no rights to the original work — only to provide additional support and styling.

## Credits

Based on brightness modules for polybar.