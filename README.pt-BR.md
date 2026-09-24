# ZipToolPro

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | <b>Português (Brasil)</b> | [Русский](README.ru.md) | [Українська](README.uk.md) | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro é um gerenciador de arquivos compactados rápido e nativo para macOS. Você pode navegar pelos arquivos sem extraí-los, abrir arquivos aninhados diretamente, extrair só o que precisa e criar arquivos compactados com senha opcional.

<p align="center">
  <a href="https://apps.apple.com/br/app/id6778828246"><img src="assets/mas.svg" alt="Mac App Store" height="48"></a>
</p>

<p align="center">Grátis na Mac App Store como <b>Ferramenta de Arquivos</b></p>

## Capturas de tela

<p align="center">
  <img src="assets/screenshots/pt-BR/01.jpg" alt="Screenshot 1" width="100%">
</p>
<p align="center">
  <img src="assets/screenshots/pt-BR/02.jpg" alt="Screenshot 2" width="100%">
</p>

## Recursos

- **Navegue sem extrair**: abra um arquivo compactado e veja o conteúdo na hora
- **Arquivos aninhados**: abra um arquivo compactado dentro de outro sem extrair o externo
- **Extraia só o necessário**: extraia arquivos ou pastas individuais, ou tudo de uma vez
- **Criar arquivos compactados**: ZIP, 7Z, GZIP, BZIP2 e XZ, com proteção por senha quando o formato permite
- **Arquivos criptografados**: abra arquivos compactados protegidos por senha
- **Visualização Rápida (Quick Look)**: pré-visualize o conteúdo no Finder com a barra de espaço
- **36 formatos**: 7z, zip, zipx, rar, tar, gz, bz2, xz, lz4, z, cab, arj, lha, sit, sitx, iso, dmg, pkg, xar, rpm, cpio, msi, wim, squashfs, vhd, vhdx, vmdk, vdi, qcow2 e outros
- **13 idiomas**: English, 简体中文, 日本語, 한국어, Deutsch, Français, Español, Italiano, Português (Brasil), Русский, Українська, Polski, فارسی

## Requisitos

- macOS 12.0 ou posterior
- Xcode 16 ou posterior (para compilar a partir do código-fonte)

## Compilar a partir do código-fonte

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# Edite SigningOverride.xcconfig e defina DEVELOPMENT_TEAM com o seu Team ID
open ZipToolPro.xcodeproj
```

Se você clonou sem `--recursive`, execute:

```bash
git submodule update --init --recursive
```

## Contribuir

Issues e pull requests são bem-vindos. Ao relatar um bug, informe sua versão do macOS, sua versão do ZipToolPro e, se possível, um arquivo de exemplo.

## Apoie o projeto

Se o ZipToolPro for útil para você, apoie o desenvolvimento escaneando o QR code abaixo com o Alipay. Obrigado!

<p align="center"><img src="assets/sponsor/alipay.jpg" alt="Alipay" width="240"></p>

## Licença

Copyright © 2026 huzitonglover

ZipToolPro é software livre, distribuído sob a [Licença Pública Geral GNU v3.0](LICENSE).

## Agradecimentos

- Derivado originalmente do [MacPacker](https://github.com/sarensw/MacPacker), de sarensw (GPL-3.0)
- O suporte a formatos é fornecido por [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
