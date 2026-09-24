# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | **Русский** | [Українська](README.uk.md) | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro — быстрый нативный архиватор для macOS. Просматривайте архивы без распаковки, открывайте вложенные архивы напрямую, извлекайте только нужные файлы и создавайте сжатые архивы, при желании защищённые паролем.

## Возможности

- **Просмотр без распаковки**: откройте архив и сразу увидите его содержимое
- **Вложенные архивы**: открывайте архив внутри другого архива, не распаковывая внешний
- **Извлекайте только нужное**: отдельные файлы и папки или всё содержимое целиком
- **Создание архивов**: ZIP, 7Z, GZIP, BZIP2 и XZ с защитой паролем, если формат её поддерживает
- **Зашифрованные архивы**: открытие архивов, защищённых паролем
- **Быстрый просмотр (Quick Look)**: предпросмотр содержимого архива в Finder по нажатию пробела
- **36 форматов**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 и другие
- **13 языков**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Системные требования

- macOS 12.0 или новее
- Xcode 16 или новее (для сборки из исходного кода)

## Сборка из исходного кода

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Откройте SigningOverride.xcconfig и укажите свой Team ID в DEVELOPMENT_TEAM
open ZipToolPro.xcodeproj
```

Если вы клонировали без `--recursive`, выполните:

```bash
git submodule update --init --recursive
```

## Участие в разработке

Issues и pull request’ы приветствуются. Сообщая об ошибке, укажите версию macOS, версию ZipToolPro и, по возможности, приложите пример архива.

## Поддержать проект

Если ZipToolPro вам полезен, вы можете поддержать разработку, отсканировав QR-код ниже в Alipay. Спасибо!

<p align="center"><img src="assets/sponsor/alipay.jpg" alt="Alipay" width="240"></p>

## Лицензия

Copyright © 2026 huzitonglover

ZipToolPro — свободное программное обеспечение, распространяемое по [лицензии GNU GPL v3.0](LICENSE).

## Благодарности

- Изначально основан на [MacPacker](https://github.com/sarensw/MacPacker) от sarensw (GPL-3.0)
- Поддержка форматов обеспечивается [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
