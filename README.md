#  C+++ IDE 1.0.1 for macOS 使用帮助（中文）
- C+++ IDE 1.0 for macOS —— Mac上最简洁的C+++IDE。

## 介绍
> C+++是macOS平台上的一款轻量级C++编译器，界面简洁，使用方便，适合使用macOS的C++初学者使用。包含代码高亮、自动配对括号、自动缩进等功能，并且支持深色模式以及MacBook Pro的触控栏操作。安装C+++以后，您不用打开Xcode(*)，创建Xcode Project以后进行C++编辑，也不用在终端使用g++对cpp源文件进行编译，一切工作全在C+++应用里完成。  

## 右边的“编译”界面是干什么的？
### 介绍
- File Path: 文件所在的路径。
- Folder Path: 文件所在的文件夹的路径。
- Compile and execute in Terminal: 是否编译出一个exec文件并在“终端”里打开。
> 比如一个文件的位置是/Users/Apple/Desktop/a.cpp, 那么文件夹的路径就会是/Users/Apple/Desktop。

### 要来干什么用呢？
***首先Compile and execute in Terminal: 这个必须勾选。***
- 也不知道为什么，我在开发C+++的时候可以不勾选，编译成功，但是导出.app应用以后不勾选就没法用了。

### 编译命令
cd <Folder Path> // 这一步其实不需要，但是还是留着了，万一以后开发需要。
g++ -o <File Path + output> <File Path> // 每次编译输出一个output的Unix可执行文件。
open <File Path + output> // 使用终端打开那个可执行文件。

## 设置界面
- 支持设置字体、字体大小、代码高亮主题、是否自动补全括号。

## Xcode
- 使用g++编译器需要使用Xcode。所以您可以从App Store中下载Xcode（比较大，需要一会儿时间）。
- 如果不从App Store获取，可以从developer.apple.com/downloads中获取（需要使用Apple ID登录）。

## 其他的操作大家应该都懂！点击右上角的“✔️”进行编译。
