---
layout: page
title: Getting Started
permalink: /getting-started/
---

## Getting started

## Environment setup

When using nodejs-18.x in Amazon Linux, it requires glibc-2.28, meanwhile, compiling glibc-2.28 requires make-4.x or later[^1].

```console
$ wget https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
$ tar -xzvf make-4.3.tar.gz 
$ cd make-4.3/
$ ./configure  --prefix=/usr
$ make
$ make install
```
Once make-4.x or later is ready, we may start to compiling glibc-2.28 on Amazon Linux. However, during `make install` there would be an error due to `cannot found -lnss_test2` which could be ignored[^2].

```console
$ wget https://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.gz
$ tar -xzvf glibc-2.28.tar.gz
$ cd glibc-2.28
$ mkdir build && cd build
$ ../configure --prefix=/usr --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
$ make
$ make install
...
/usr/bin/ld: cannot find -lnss_test2
collect2: error: ld returned 1 exit status
Execution of gcc -B/usr/bin/ failed!
...
```

To test if the installation of the compiled glibc-2.28 is success or not, we may check if `GLIBC_2.28` is enabled[^1] [^2].

```console
$ ls -l /lib64/libc.so.6
lrwxrwxrwx 1 root root 12 Jul 3 15:14 /lib64/libc.so.6 -> libc-2.28.so
$ strings /lib64/libc.so.6 | grep GLIBC
...
GLIBC_2.22
GLIBC_2.23
GLIBC_2.24
GLIBC_2.25
GLIBC_2.26
GLIBC_2.27
GLIBC_2.28
GLIBC_PRIVATE
...
```
---

[^1]: [Centos 7 升级 Glibc-2.28](https://cloud.tencent.com/developer/article/2021784)

[^2]: [CentOS 7.6 编译安装最新版本glibc2.30 实录](https://www.jianshu.com/p/1070373a50f6)