# Enhanced WiFi Menu for Linux Desktop

This package provides enhanced WiFi menu and status modules for Linux desktop.

## Files Included

1. **wifimenu-podobu** - Main WiFi menu script
2. **network-wifi.sh** - WiFi status display script
3. **user_modules.ini** - Module configuration
4. **README.md** - This file

---

## Features

- Network scanning with signal strength
- Saved network detection
- Try Again feature for changed passwords
- Auto Connection toggle
- Network Information menu
- Remove All Saved Networks option
- Works with rofi, wofi, dmenu

---

<p align="center">
  <img src="Screenshots/4.png" width="400"/>
  <img src="Screenshots/2.png" width="400"/>
  <img src="Screenshots/3.png" width="400"/>
</p>

---

## Installation

### Step 1: Create Directory
mkdir -p ~/YourPath

### Step 2: Copy Files
cp wifimenu-podobu ~/YourPath/
cp network-wifi.sh ~/YourPath/
cp user_modules.ini ~/YourPath/

### Step 3: Make Executable
chmod +x ~/YourPath/wifimenu-podobu
chmod +x ~/YourPath/network-wifi.sh

### Step 4: Create Wrapper (Optional)
Create wifimenu.sh:
```bash
#!/bin/bash
while true; do
    ~/YourPath/wifimenu-podobu "$@"
    [ $? -ne 42 ] && break
done
```

### Step 5: Update Paths
Edit user_modules.ini - change ~/YourPath/ to your path.

---

## Requirements

- Linux desktop
- NetworkManager
- rofi or wofi or dmenu
- Nerd Fonts

---

## Contribution

This is a customized version of the original wifimenu created by Jesús Arenas (podobu). I, Anindra Mohan Trivedi, have modified it to add modern features and improvements.

I claim no rights to the original work — only to provide additional support and styling.

## Credits

Based on wifimenu by Jesús Arenas (podobu)