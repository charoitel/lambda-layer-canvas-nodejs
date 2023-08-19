# Canvas Layer for AWS Lambda

![GitHub](https://img.shields.io/github/license/charoitel/lambda-layer-canvas-nodejs)

Canvas Layer for AWS Lambda is published and available on [AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs), and GitHub at [charoitel/lambda-layer-canvas-nodejs](https://github.com/charoitel/lambda-layer-canvas-nodejs). The layer aims to provide a Cairo backed Mozilla Web Canvas API implementation layer for AWS Lambda, powered by [node-canvas](https://github.com/Automattic/node-canvas).

## About node-canvas

[node-canvas](https://github.com/Automattic/node-canvas) is a Cairo backed Canvas implementation for Node.js. It implements the [Mozilla Web Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) as closely as possible. For the latest API compliance, you may check [Compatibility Status](https://github.com/Automattic/node-canvas/wiki/Compatibility-Status).

## How this layer is built?

The layer is built from source of node-canvas npm package on [amazonlinux](https://hub.docker.com/_/amazonlinux) dev container instance, with following native dependencies installed. You may check the build layer script, ``` build-layer.sh ```, which is available in repository, for details.

```bash
gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq python3
```

Since AWS Lambda is a secure and isolated runtime and execution environment, the layer aims to target AWS Lambda compatible and native build. As there are canvas libraries and frameworks relying on node-canvas running on Node.js runtime, this layer may also try to include and support those libraries and frameworks. Currently, following libraries and frameworks are included when building and packaging the layer:

- [Chart.js](#chartjs-support)
- [Fabric.js](#fabricjs-support)
- [Konva](#konva-support)
- [PixiJS](#pixijs-support)

### Chart.js support

[Chart.js](https://github.com/chartjs/chart.js) provides a set of frequently used chart types, plugins, and customization options. In addition to a reasonable set of built-in chart types, there are also community-maintained chart types.

### Fabric.js support

[Fabric.js](https://github.com/fabricjs/fabric.js) provides a missing and interactive object model for canvas, as well as an SVG parser, layer of interactivity, and a whole suite of other indispensable tools.

### Konva support

[Konva](https://github.com/konvajs/konva) enables high performance animations, transitions, node nesting, layering, filtering, caching, event handling for desktop and mobile applications, and much more.

### PixiJS support

[PixiJS](https://github.com/pixijs/pixijs) aims to provide a fast, lightweight 2D library that works across all devices. The renderer allows everyone to enjoy the power of hardware acceleration without prior knowledge of WebGL.
