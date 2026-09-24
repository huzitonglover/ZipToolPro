# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | **Deutsch** | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | [Українська](README.uk.md) | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro ist ein schneller, nativer Archivmanager für macOS. Du kannst Archive durchsuchen, ohne sie zu entpacken, verschachtelte Archive direkt öffnen, nur die benötigten Dateien extrahieren und komprimierte Archive – auf Wunsch mit Passwort – erstellen.

## Funktionen

- **Durchsuchen ohne Entpacken**: Archiv öffnen und den Inhalt sofort ansehen
- **Verschachtelte Archive**: ein Archiv innerhalb eines anderen öffnen, ohne das äußere zuerst zu entpacken
- **Gezielt entpacken**: einzelne Dateien oder Ordner extrahieren oder alles auf einmal
- **Archive erstellen**: ZIP, 7Z, GZIP, BZIP2 und XZ, mit Passwortschutz, sofern das Format ihn unterstützt
- **Verschlüsselte Archive**: passwortgeschützte Archive öffnen
- **Übersicht (Quick Look)**: Archivinhalte im Finder mit der Leertaste in der Vorschau anzeigen
- **36 Formate**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 und weitere
- **13 Sprachen**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Voraussetzungen

- macOS 12.0 oder neuer
- Xcode 16 oder neuer (zum Bauen aus dem Quellcode)

## Aus dem Quellcode bauen

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# SigningOverride.xcconfig bearbeiten und DEVELOPMENT_TEAM auf deine Team-ID setzen
open ZipToolPro.xcodeproj
```

Falls du ohne `--recursive` geklont hast, führe Folgendes aus:

```bash
git submodule update --init --recursive
```

## Mitwirken

Issues und Pull Requests sind willkommen. Gib bei Fehlerberichten bitte deine macOS-Version, deine ZipToolPro-Version und nach Möglichkeit ein Beispielarchiv an.

## Unterstützen

Wenn dir ZipToolPro gefällt, kannst du die Weiterentwicklung unterstützen, indem du den QR-Code unten mit Alipay scannst. Vielen Dank!

<p align="center"><img src="assets/sponsor/alipay.jpg" alt="Alipay" width="240"></p>

## Lizenz

Copyright © 2026 huzitonglover

ZipToolPro ist freie Software und wird unter der [GNU General Public License v3.0](LICENSE) veröffentlicht.

## Danksagung

- Ursprünglich abgeleitet von [MacPacker](https://github.com/sarensw/MacPacker) von sarensw (GPL-3.0)
- Die Archivunterstützung basiert auf [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
