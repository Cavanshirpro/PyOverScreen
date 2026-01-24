# PyOverScreen
[👉👉👉DOWNLOAD .EXE HERE!!! CLICK HERE!!! NO PYTHON NEEDED!👈👈👈](https://github.com/JustLachin/PyOverScreen/releases/download/v1/PyOverScreen.zip)

PyOverScreen is a powerful overlay management tool built with PySide6. It allows you to create, manage, and customize multiple overlays on your screen with ease.

## Features:
- Create multiple independent overlays.
- Customize position, size, scale, and opacity.
- Support for URLs, local images, GIFs, and Videos.
- Lock/Unlock overlays for interaction or click-through.
- Save and load profiles.
- Target specific game windows for forced visibility. (May not working due to Windows security.)

## Installation
1. Install Python 3.10+
2. Install dependencies:
   ```bash
   pip install PySide6 pygame
   ```

## Running the App
```bash
python PyOverScreen.py
```

## Building EXE
```bash
pyinstaller --noconsole --onedir --add-data "src;src" PyOverScreen.py
```

## License
MIT License. Use at your own risk.
