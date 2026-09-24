# ZipToolPro

**English** | [简体中文](README.zh-CN.md)

ZipToolPro is a fast, native archive manager for macOS. You can browse archives without extracting them, open nested archives in place, extract only the files you need, and create compressed archives with optional passwords.

## Features

- **Browse without extracting**: open an archive and look through its contents right away
- **Nested archives**: open an archive inside another archive without extracting the outer one first
- **Extract what you need**: pull out single files or folders, or extract everything
- **Create archives**: ZIP, 7Z, GZIP, BZIP2, and XZ, with password protection where the format supports it
- **Encrypted archives**: open password-protected archives
- **Quick Look**: preview archive contents in Finder with the space bar
- **36 formats**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2, and more
- **13 languages**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Requirements

- macOS 12.0 or later
- Xcode 16 or later (to build from source)

## Build from source

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Edit SigningOverride.xcconfig and set DEVELOPMENT_TEAM to your Team ID
open ZipToolPro.xcodeproj
```

If you cloned without `--recursive`, run:

```bash
git submodule update --init --recursive
```

## Contributing

Issues and pull requests are welcome. For bugs, please include your macOS version, your ZipToolPro version, and a sample archive if possible.

## License

Copyright © 2026 huzitonglover

ZipToolPro is free software, released under the [GNU General Public License v3.0](LICENSE).

## Acknowledgements

- Originally derived from [MacPacker](https://github.com/sarensw/MacPacker) by sarensw (GPL-3.0)
- Archive support is powered by [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), and [SWCompression](https://github.com/tsolomko/SWCompression)
