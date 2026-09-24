# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | **Español** | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | [Українська](README.uk.md) | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro es un gestor de archivos comprimidos rápido y nativo para macOS. Puedes explorar archivos sin descomprimirlos, abrir archivos anidados directamente, extraer solo lo que necesitas y crear archivos comprimidos con contraseña opcional.

## Funciones

- **Explorar sin descomprimir**: abre un archivo comprimido y revisa su contenido al instante
- **Archivos anidados**: abre un archivo comprimido que está dentro de otro sin descomprimir el exterior
- **Extrae solo lo necesario**: extrae archivos o carpetas individuales, o todo el contenido
- **Crear archivos comprimidos**: ZIP, 7Z, GZIP, BZIP2 y XZ, con protección por contraseña cuando el formato lo admite
- **Archivos cifrados**: abre archivos comprimidos protegidos con contraseña
- **Vista rápida (Quick Look)**: previsualiza el contenido en Finder con la barra espaciadora
- **36 formatos**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 y más
- **13 idiomas**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Requisitos

- macOS 12.0 o posterior
- Xcode 16 o posterior (para compilar desde el código fuente)

## Compilar desde el código fuente

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Edita SigningOverride.xcconfig y establece DEVELOPMENT_TEAM con tu Team ID
open ZipToolPro.xcodeproj
```

Si clonaste sin `--recursive`, ejecuta:

```bash
git submodule update --init --recursive
```

## Contribuir

Los issues y pull requests son bienvenidos. Al reportar un error, incluye tu versión de macOS, tu versión de ZipToolPro y, si es posible, un archivo de ejemplo.

## Licencia

Copyright © 2026 huzitonglover

ZipToolPro es software libre, publicado bajo la [Licencia Pública General de GNU v3.0](LICENSE).

## Agradecimientos

- Derivado originalmente de [MacPacker](https://github.com/sarensw/MacPacker) de sarensw (GPL-3.0)
- La compatibilidad con formatos se basa en [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
