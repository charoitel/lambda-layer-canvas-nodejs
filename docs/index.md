---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

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