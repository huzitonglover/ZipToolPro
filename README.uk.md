# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | **Українська** | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro — швидкий нативний архіватор для macOS. Переглядайте архіви без розпакування, відкривайте вкладені архіви напряму, видобувайте лише потрібні файли та створюйте стиснені архіви, за бажанням захищені паролем.

## Можливості

- **Перегляд без розпакування**: відкрийте архів і одразу побачите його вміст
- **Вкладені архіви**: відкривайте архів усередині іншого архіву, не розпаковуючи зовнішній
- **Видобувайте лише потрібне**: окремі файли й теки або весь вміст одразу
- **Створення архівів**: ZIP, 7Z, GZIP, BZIP2 і XZ із захистом паролем, якщо формат його підтримує
- **Зашифровані архіви**: відкриття архівів, захищених паролем
- **Швидкий перегляд (Quick Look)**: попередній перегляд вмісту архіву у Finder натисканням пробілу
- **36 форматів**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 та інші
- **13 мов**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Системні вимоги

- macOS 12.0 або новіша
- Xcode 16 або новіший (для збирання з вихідного коду)

## Збирання з вихідного коду

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Відкрийте SigningOverride.xcconfig і вкажіть свій Team ID у DEVELOPMENT_TEAM
open ZipToolPro.xcodeproj
```

Якщо ви клонували без `--recursive`, виконайте:

```bash
git submodule update --init --recursive
```

## Участь у розробці

Issues і pull request’и вітаються. Повідомляючи про помилку, вкажіть версію macOS, версію ZipToolPro і, за можливості, додайте приклад архіву.

## Підтримати проєкт

Якщо ZipToolPro вам корисний, ви можете підтримати розробку, відсканувавши QR-код нижче в Alipay. Дякуємо!

<p align="center"><img src="assets/sponsor/alipay.jpg" alt="Alipay" width="240"></p>

## Ліцензія

Copyright © 2026 huzitonglover

ZipToolPro — вільне програмне забезпечення, що поширюється за [ліцензією GNU GPL v3.0](LICENSE).

## Подяки

- Спочатку створено на основі [MacPacker](https://github.com/sarensw/MacPacker) від sarensw (GPL-3.0)
- Підтримку форматів забезпечують [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
