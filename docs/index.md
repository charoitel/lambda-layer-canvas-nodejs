---
layout: home
---

![GitHub](https://img.shields.io/github/license/charoitel/lambda-layer-canvas-nodejs)&nbsp;&nbsp;![Watch on GitHub](https://img.shields.io/github/watchers/charoitel/lambda-node-canvas.svg?style=social)&nbsp;&nbsp;![Fork on GitHub](https://img.shields.io/github/forks/charoitel/lambda-node-canvas.svg?style=social)&nbsp;&nbsp;![Star on GitHub](https://img.shields.io/github/stars/charoitel/lambda-node-canvas.svg?style=social)

Canvas Layer for AWS Lambda is published and available on [AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs), and GitHub at [charoitel/lambda-layer-canvas-nodejs](https://github.com/charoitel/lambda-layer-canvas-nodejs). The layer aims to provide a Cairo backed Mozilla Web Canvas API implementation layer for AWS Lambda, powered by [node-canvas](https://github.com/Automattic/node-canvas).

## About node-canvas

[node-canvas](https://github.com/Automattic/node-canvas) is a Cairo backed Canvas implementation for Node.js. It implements the [Mozilla Web Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) as closely as possible. For the latest API compliance, you may check [Compatibility Status](https://github.com/Automattic/node-canvas/wiki/Compatibility-Status).

## How this layer is built?

The layer is built from source of node-canvas npm package on [amazonlinux](https://hub.docker.com/_/amazonlinux) dev container instance, with following native dependencies installed. You may check the build layer script, ``` build-layer.sh ```, which is available in repository, for details.

```bash
gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq python3
```

Since AWS Lambda is a secure and isolated runtime and execution environment, the layer aims to target AWS Lambda compatible and native build. As there are canvas libraries and frameworks relying on node-canvas running on Node.js runtime, this layer may also try to include and support these libraries and frameworks. Currently there are two frameworks are included when building and packaging the layer:

- [Fabric.js](#fabricjs-support)
- [Konva](#konva-support)

### Fabric.js support

[Fabric.js](https://github.com/fabricjs/fabric.js) is a framework that makes it easy to work with HTML5 canvas element. It is an interactive object model on top of canvas element. It is also an SVG-to-canvas (and canvas-to-SVG) parser.

### Konva support

[Konva](https://github.com/konvajs/konva) is a framework that enables high performance animations, transitions, node nesting, layering, filtering, caching, event handling for desktop and mobile applications, and much more.
