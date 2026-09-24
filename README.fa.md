# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | [Українська](README.uk.md) | [Polski](README.pl.md) | **فارسی**

<div dir="rtl">

ZipToolPro یک ابزار مدیریت بایگانی سریع و بومی برای macOS است. بدون استخراج، محتوای بایگانی‌ها را مرور کنید، بایگانی‌های تودرتو را مستقیماً باز کنید، فقط فایل‌های مورد نیاز را استخراج کنید و بایگانی‌های فشرده، در صورت تمایل با گذرواژه، بسازید.

## ویژگی‌ها

- **مرور بدون استخراج**: بایگانی را باز کنید و بلافاصله محتوای آن را ببینید
- **بایگانی‌های تودرتو**: بایگانی درون بایگانی دیگر را بدون استخراج بایگانی بیرونی باز کنید
- **استخراج انتخابی**: فایل‌ها یا پوشه‌های جداگانه، یا همه محتوا را استخراج کنید
- **ساخت بایگانی**: ZIP، 7Z، GZIP، BZIP2 و XZ، همراه با محافظت با گذرواژه در صورت پشتیبانی قالب
- **بایگانی‌های رمزگذاری‌شده**: باز کردن بایگانی‌های محافظت‌شده با گذرواژه
- **پیش‌نمایش سریع (Quick Look)**: پیش‌نمایش محتوای بایگانی در Finder با فشردن کلید فاصله
- **۳۶ قالب**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 و موارد دیگر
- **۱۳ زبان**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## پیش‌نیازها

- macOS 12.0 یا جدیدتر
- Xcode 16 یا جدیدتر (برای ساخت از کد منبع)

## ساخت از کد منبع

<div dir="ltr">

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# SigningOverride.xcconfig را ویرایش کنید و DEVELOPMENT_TEAM را روی Team ID خود تنظیم کنید
open ZipToolPro.xcodeproj
```

</div>

اگر مخزن را بدون `--recursive` کلون کرده‌اید، این دستور را اجرا کنید:

<div dir="ltr">

```bash
git submodule update --init --recursive
```

</div>

## مشارکت

از Issue و Pull Request استقبال می‌شود. هنگام گزارش خطا، نسخه macOS، نسخه ZipToolPro و در صورت امکان یک بایگانی نمونه را ضمیمه کنید.

## مجوز

Copyright © 2026 huzitonglover

ZipToolPro یک نرم‌افزار آزاد است که تحت [مجوز عمومی همگانی گنو نسخه ۳ (GPL-3.0)](LICENSE) منتشر شده است.

## قدردانی

- در اصل برگرفته از [MacPacker](https://github.com/sarensw/MacPacker) اثر sarensw (GPL-3.0)
- پشتیبانی از قالب‌ها به لطف [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)

</div>
