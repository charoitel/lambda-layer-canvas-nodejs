# About node-canvas

[node-canvas](https://github.com/Automattic/node-canvas) is a Cairo backed Canvas implementation for Node.js by [Automattic](https://github.com/Automattic). It is an implementation of the Web Canvas API and implements that API as closely as possible. For API documentation, please visit [Mozilla Web Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API). See [Compatibility Status](https://github.com/Automattic/node-canvas/wiki/Compatibility-Status) for the current API compliance.

# About lambda-node-canvas

lambda-node-canvas is an implementation of node-canvas for manipulating vector graphics on AWS Lambda, with using AWS Lambda Layer to manage the dependency with node-canvas in order to enable inline editing of the function code.

## Getting started

To use lambda-node-canvas, please visit [application page](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~cairo-canvas-nodejs) on [AWS Serverless Application Repository](https://aws.amazon.com/serverless/serverlessrepo/), then deploy the serverless application using the **Deploy** button on the page.

The deployment of the serverless application may take a few minutes, once the application is deployed and ready, the code of the *Function* could be edited using inline code editor in AWS Lambda console.
