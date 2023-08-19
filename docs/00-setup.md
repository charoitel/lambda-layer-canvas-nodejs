---
layout: page
title: Setup
permalink: /setup/
---

## Prerequisites

In order to start to use [lambda-layer-canvas-nodejs](https://github.com/charoitel/lambda-layer-canvas-nodejs) published on [AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs), you must have your AWS account with following services available:

- [AWS Serverless Application Repository](https://aws.amazon.com/serverless/serverlessrepo)
- [AWS Lambda](https://aws.amazon.com/lambda)

## Serverless application deployment

Once you have your AWS account ready, there are two ways to deploy [lambda-layer-canvas-nodejs](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs) and make it available in your AWS Lambda console:

- [Deploy through AWS Serverless Application Repository](#deploy-through-aws-serverless-application-repository)
- [Deploy through AWS Lambda console](#deploy-through-aws-lambda-console)

### Deploy through AWS Serverless Application Repository

1. Open https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs
2. Click **Deploy** button
3. Login to your AWS account if you haven't login yet
4. Edit **_Name_** (Optional)
5. Click **Deploy** button
6. Deployment is started and in progress
7. Check your AWS Lambda console once the deployment is completed

### Deploy through AWS Lambda console

1. Login to your AWS account and open your AWS Lambda console
2. Click **Create application** button
3. Select **_Serverless application_**
4. Input `lambda-layer-canvas-nodejs` into search box and press _Enter_ key
5. Click on the title of `lambda-layer-canvas-nodejs` card
6. Edit **_Name_** (Optional)
7. Click **Deploy** button
8. Deployment is started and in progress
9. Check your AWS Lambda console once the deployment is completed

### Using canvas layer

After the deployment is completed, you may refer [usage example](/lambda-layer-canvas-nodejs/{% link 01-use.md %}) and follow the example where a Lambda function uses the canvas layer to generate PNG graphic with colored text and circle rendered.

## Setup environment to build the layer

Alternately, you may setup your own environment to build the layer according to your specific needs. When using the layer with nodejs-18.x in Amazon Linux, it requires glibc-2.28, meanwhile, compiling glibc-2.28 requires make-4.x or later[^1].

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

Once your environment is ready, you may execute the build layer script, ``` build-layer.sh ```, to build the layer and deploy through the AWS Lambda console.

---

[^1]: [Centos 7 升级 Glibc-2.28](https://cloud.tencent.com/developer/article/2021784)
[^2]: [CentOS 7.6 编译安装最新版本glibc2.30 实录](https://www.jianshu.com/p/1070373a50f6)