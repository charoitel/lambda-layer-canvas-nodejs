# Canvas Layer for AWS Lambda

![GitHub](https://img.shields.io/github/license/charoitel/lambda-layer-canvas-nodejs)&nbsp;&nbsp;![Watch on GitHub](https://img.shields.io/github/watchers/charoitel/lambda-node-canvas.svg?style=social)&nbsp;&nbsp;![Fork on GitHub](https://img.shields.io/github/forks/charoitel/lambda-node-canvas.svg?style=social)&nbsp;&nbsp;![Star on GitHub](https://img.shields.io/github/stars/charoitel/lambda-node-canvas.svg?style=social)

[lambda-layer-canvas-nodejs](https://github.com/charoitel/lambda-layer-canvas-nodejs) published on [AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs) packages node-canvas and its dependencies as AWS Lambda Layer.

## About node-canvas

[node-canvas](https://github.com/Automattic/node-canvas) is a Cairo backed Canvas implementation for Node.js. It implements the [Mozilla Web Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) as closely as possible. For the current API compliance, please check [Compatibility Status](https://github.com/Automattic/node-canvas/wiki/Compatibility-Status).

## How this layer is built?

The Lambda Layer is built from source of node-canvas npm package on EC2 instance, with following native dependencies installed. Please check ``` build-layer.sh ``` for details.

```console
gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq python3
```

Since AWS Lambda is a secure and isolated runtime and execution environment, this layer aims to target AWS Lambda compatible build. As there are canvas libraries and frameworks relying on node-canvas running on Node.js runtime, this layer also tries to include and support these libraries and frameworks.

### Fabric.js support

[Fabric.js](https://github.com/fabricjs/fabric.js) is a framework that makes it easy to work with HTML5 canvas element. It is an interactive object model on top of canvas element. It is also an SVG-to-canvas (and canvas-to-SVG) parser.

### Konva support

[Konva](https://github.com/konvajs/konva) is a framework that enables high performance animations, transitions, node nesting, layering, filtering, caching, event handling for desktop and mobile applications, and much more.

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