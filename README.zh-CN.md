# ZipToolPro

[English](README.md) | **简体中文** | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Italiano](README.it.md) | [Português (Brasil)](README.pt-BR.md) | [Русский](README.ru.md) | [Українська](README.uk.md) | [Polski](README.pl.md) | [فارسی](README.fa.md)

ZipToolPro 是一款快速、原生的 macOS 压缩包管理工具：无需解压即可浏览压缩包内容，可以直接打开嵌套的压缩包，只提取需要的文件，还能创建带密码的压缩包。

## 功能

- **免解压浏览**：打开压缩包即可查看里面的所有内容
- **嵌套压缩包**：压缩包里的压缩包也能直接打开，不用先解压外层
- **按需提取**：可以只提取单个文件或文件夹，也可以全部解压
- **创建压缩包**：支持 ZIP、7Z、GZIP、BZIP2、XZ，格式支持时可设置密码
- **加密压缩包**：支持打开有密码保护的压缩包
- **快速查看**：在访达里按空格键即可预览压缩包内容
- **36 种格式**：7z、zip、zipx、rar、tar、gz、bz2、xz、lz4、z、cab、arj、lha、sit、sitx、iso、dmg、pkg、xar、rpm、cpio、msi、wim、squashfs、vhd、vhdx、vmdk、vdi、qcow2 等
- **13 种语言**：English、简体中文、日本語、한국어、Deutsch、Français、Español、Italiano、Português (Brasil)、Русский、Українська、Polski、فارسی

## 系统要求

- macOS 12.0 或更高版本
- Xcode 16 或更高版本（从源码构建时需要）

## 从源码构建

```bash
git clone --recursive https://github.com/huzitonglover/ZipToolPro.git
cd ZipToolPro
cp Config/SigningOverride.xcconfig.template Config/SigningOverride.xcconfig
# 编辑 SigningOverride.xcconfig，把 DEVELOPMENT_TEAM 改成你自己的 Team ID
open ZipToolPro.xcodeproj
```

如果克隆时没加 `--recursive`，请运行：

```bash
git submodule update --init --recursive
```

## 参与贡献

欢迎提交 Issue 和 Pull Request。报告问题时，请附上你的 macOS 版本、ZipToolPro 版本，方便的话再附一个能复现问题的压缩包。

## 许可证

Copyright © 2026 huzitonglover

ZipToolPro 是自由软件，基于 [GNU 通用公共许可证 v3.0（GPL-3.0）](LICENSE) 发布。

## 致谢

- 最初源自 sarensw 的 [MacPacker](https://github.com/sarensw/MacPacker)（GPL-3.0）
- 压缩格式支持来自 [7-Zip](https://github.com/ip7z/7zip), [XADMaster](https://github.com/sarensw/XADMasterSwift), [SWCompression](https://github.com/tsolomko/SWCompression)
