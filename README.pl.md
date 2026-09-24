# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | [Українська](README.uk.md) | **Polski** | [فارسی](README.fa.md)

ZipToolPro to szybki, natywny menedżer archiwów dla macOS. Przeglądaj archiwa bez rozpakowywania, otwieraj zagnieżdżone archiwa bezpośrednio, wypakowuj tylko potrzebne pliki i twórz skompresowane archiwa, opcjonalnie zabezpieczone hasłem.

## Funkcje

- **Przeglądanie bez rozpakowywania**: otwórz archiwum i od razu zobacz jego zawartość
- **Zagnieżdżone archiwa**: otwieraj archiwum znajdujące się w innym archiwum bez rozpakowywania zewnętrznego
- **Wypakuj tylko to, czego potrzebujesz**: pojedyncze pliki lub foldery albo całą zawartość
- **Tworzenie archiwów**: ZIP, 7Z, GZIP, BZIP2 i XZ, z ochroną hasłem, jeśli format ją obsługuje
- **Zaszyfrowane archiwa**: otwieranie archiwów chronionych hasłem
- **Szybki podgląd (Quick Look)**: podgląd zawartości archiwum w Finderze po naciśnięciu spacji
- **36 formatów**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 i inne
- **13 języków**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Wymagania

- macOS 12.0 lub nowszy
- Xcode 16 lub nowszy (do kompilacji ze źródeł)

## Kompilacja ze źródeł

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Edytuj SigningOverride.xcconfig i ustaw DEVELOPMENT_TEAM na swój Team ID
open ZipToolPro.xcodeproj
```

Jeśli sklonowano repozytorium bez `--recursive`, uruchom:

```bash
git submodule update --init --recursive
```

## Współtworzenie

Zgłoszenia (issues) i pull requesty są mile widziane. Zgłaszając błąd, podaj wersję macOS, wersję ZipToolPro oraz, jeśli to możliwe, przykładowe archiwum.

## Licencja

Copyright © 2026 huzitonglover

ZipToolPro jest wolnym oprogramowaniem, udostępnianym na [licencji GNU General Public License v3.0](LICENSE).

## Podziękowania

- Pierwotnie oparty na [MacPacker](https://github.com/sarensw/MacPacker) autorstwa sarensw (GPL-3.0)
- Obsługę formatów zapewniają [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
