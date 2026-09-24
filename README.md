# ZipToolPro

ZipToolPro is an archive manager for macOS. You can browse archives (including nested ones) without extracting them, extract single files, and preview contents with Quick Look.

## Features

- Supports common formats: zip, 7z, rar, tar, gz, bz2, xz, wim, and more (built on 7-Zip)
- Browse nested archives without extracting them
- Extract single files or entire archives
- Open password-protected / encrypted archives
- Quick Look extension
- Localized in English, Chinese, Japanese, Korean, German, French, Spanish, Italian, Portuguese, Russian, Ukrainian, Polish, and Persian

## Build

Requirements: macOS with Xcode 16 or later.

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Set DEVELOPMENT_TEAM to your own Team ID
open ZipToolPro.xcodeproj
```

If you already cloned without `--recursive`, run `git submodule update --init --recursive`.

## Acknowledgements

This project is based on [MacPacker](https://github.com/sarensw/MacPacker) by [sarensw](https://github.com/sarensw), licensed under GPL-3.0.

It uses [7-Zip](https://github.com/ip7z/7zip) by Igor Pavlov (see `Modules/Sources/CSevenZip/vendor/7zip/DOC/License.txt`).

## License

[GPL-3.0](LICENSE)
