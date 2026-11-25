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

## Building the Windows x64 ZIP

From PowerShell 7 with Python 3.13 x64 installed:

```powershell
python -m pip install -r requirements-build.txt
./scripts/build-windows.ps1
```

Extract `artifacts/PyOverScreen-windows-x64.zip` and open
`PyOverScreen/PyOverScreen.exe`. Keep the entire folder together. Python is
only required to build the package. The ZIP uses Windows system fonts.

## Publishing a GitHub release

1. Open a successful **Build Release Artifacts** run for the current commit on
   `main`. Its run ID is the last number in its URL. You can also build manually
   from `main`.
2. Run **Publish Release** from `main` with mode `validate`, that run ID, and
   a new tag such as `v1.1.0` or `v1.1.0-rc.1`.
3. Run **Publish Release** again with mode `publish` and the same inputs. It
   verifies the build again and publishes the ZIP, SHA-256 file, and generated
   release notes. The tag points to the commit that produced the build.

For an approval step, configure required reviewers and restrict deployments to
`main` in the repository's `release` environment. If an interrupted upload leaves
a draft, inspect the draft before retrying with the same tag.

## License
MIT License. Use at your own risk.
