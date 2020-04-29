# Changes on this repository

Due to the size of dependencies, i.e. node_modules folder, it is no longer available to edit any serverless app based on this blueprint using AWS Lambda inline editor with node-canvas version 2.0+. So, I update this repository as resource space for those who would like to use node-canvas in their AWS Lambda functions.

In order to use node-canvas on AWS Lambda, there is an official guide from [Automattic](https://github.com/Automattic). For native dependencies like libcairo.so.2 and others, you may use the files I uploaded to this repostory.

# Getting node-canvas works on AWS Lambda

Node canvas is a Cairo backed Canvas implementation for NodeJS by [Automattic](https://github.com/Automattic). Following is the snapshot of Installation Guide from [official wiki](https://github.com/Automattic/node-canvas) last updated on Sep 3, 2018.

**Canvas 2.0 and 1.6 works out-of-the-box on AWS Lambda thanks to prebuilds. However, you must build your Lambda ZIP file on Linux (or a Linux Docker container) so that the correct prebuilt binary is included.** See https://github.com/Automattic/node-canvas/issues/1231 for more info.

The below instructions can be used for older versions or custom builds.

---

Lambda doesn't have the required libraries installed by default, but it can load them from either the `./` or `./lib` directories in your packaged function.

Create an EC2 VM from the [the Lambda AMI](https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html), we'll use this to build canvas and grab compatible libraries. 

Install Node and development tools:

```bash
sudo yum groupinstall "Development Tools" -y
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Exit SSH session and reopen here to make nvm available

# Node 6.10:
nvm install 6.10
# Or Node 8.10:
nvm install 8.10
```

Install node-canvas as you normally would on Linux:

```bash
sudo yum install cairo-devel libjpeg-turbo-devel giflib-devel pango-devel -y
npm install canvas@next
```

Then copy the system libraries from `/usr/lib64/` into a `./lib/` subdirectory for your Lambda function:

```
mkdir lib
cp /usr/lib64/{libpng12.so.0,libjpeg.so.62,libpixman-1.so.0,libfreetype.so.6,\
libcairo.so.2,libpango-1.0.so.0,libpangocairo-1.0.so.0,libpangoft2-1.0.so.0} lib/
```

At this point you can package up the `node_modules` and `lib` directories and download them to your local machine. The `node_modules/canvas/build/Release/canvas.node` library has been built for the Lambda architecture, so don't overwrite it by rebuilding the canvas package on your local machine.

Then you can add an `index.js` handler to test Canvas with:

```js
let
	{createCanvas} = require("canvas");

function hello(event, context, callback) {
	let
		canvas = createCanvas(200, 200),
		ctx = canvas.getContext('2d');

	// Write "Awesome!"
	ctx.font = '30px Impact';
	ctx.rotate(0.1);
	ctx.fillText('Awesome!', 50, 100);

	// Draw line under text
	let
		text = ctx.measureText('Awesome!');
	ctx.strokeStyle = 'rgba(0,0,0,0.5)';
	ctx.beginPath();
	ctx.lineTo(50, 102);
	ctx.lineTo(50 + text.width, 102);
	ctx.stroke();

	callback(null, '<img src="' + canvas.toDataURL() + '" />');
}

module.exports = {hello};
```

You can now zip up this function and manually deploy it to Lambda (just set Node to 6.10 and the handler to `index.hello`), or you can deploy it using [Serverless](https://serverless.com/). For Serverless, add a `serverless.yml` file to the root of your project:

```
service: canvas-test

provider:
  name: aws
  runtime: nodejs6.10
  stage: dev
  region: us-east-1
  memorySize: 128
  timeout: 10

functions:
  hello:
    handler: index.hello
```

The resulting project structure:

```
├── index.js
├── lib
│   ├── libcairo.so.2
│   ├── libfreetype.so.6
│   ├── libjpeg.so.62
│   ├── libpango-1.0.so.0
│   ├── libpangocairo-1.0.so.0
│   ├── libpangoft2-1.0.so.0
│   ├── libpixman-1.so.0
│   └── libpng12.so.0
├── node_modules
│   ├── canvas
│           ....
│   └── nan
│           ....
└── serverless.yml
```

Call `serverless deploy` to deploy it to Lambda, and `serverless invoke --function hello` to run it, and you should get back the HTML for this successful result:

![download](https://user-images.githubusercontent.com/1921411/36058675-c8f79756-0e8b-11e8-8b85-ea7ac4e3d150.png)

## Using newer versions of libcairo

The version of Amazon Linux that Lambda uses includes libcairo v1.12, which produces noticeably poor results when downscaling images with `drawImage()`. This was fixed in Cairo v1.14. You can use the install instructions for EC2 ([[Installation - Amazon-Linux-AMI-(EC2)]]) to build libcairo 1.14 and libpixman 0.34 from source, and replace the `libcairo.so.2` and `libpixman-1.so.0` binaries in your Lambda's `lib` directory with the resulting libraries (you can find those built libraries in `/usr/local/lib`).

However, due to the ordering of the directories in Lambda's `LD_LIBRARY_PATH` (`/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib`) the operating system's included libcairo and libpixman will be used instead of the copies in your Lambda's `lib` directory. To fix this you need to set LDFLAGS during canvas installation:

```bash
export LDFLAGS=-Wl,-rpath=/var/task/lib
npm install canvas@next
```

This will set the RPATH flags in the built `canvas.node` library to look for libraries in `/var/task/lib` first (your Lambda's bundled `lib` directory). Update the copy of `canvas.node` in your Lambda's `lib` directory with this newly-built version.
