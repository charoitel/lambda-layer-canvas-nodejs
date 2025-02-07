#!/bin/sh
#
# Setup environment before build layer
# yum update -y
# yum groupinstall "Development Tools" -y
# yum install gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq python3 -y
#
# Setting Up Node.js, refer https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html for details
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# . ~/.nvm/nvm.sh
# nvm install --lts
#
set -e

LAYER_NAME=canvas-nodejs
LAYER_DESCRIPTION="Cairo backed Mozilla Web Canvas API implementation layer for AWS Lambda"
LAYER_VERSION=2.11.5
LAYER_AUTHOR="Charoite Lee"

DOT_CHAR="."
NODE_VERSION=$(node -v)
NODE_VERSION=${NODE_VERSION:1}
SEMVER_VERSION=7.6.3

# Remove packaged layer if exists
if [ -n "$(find . -name 'canvas-nodejs_v*.zip')" ]; then
    rm canvas-nodejs_v*.zip
fi

# Clean and prepare Node.js modules and dependencies
if [ "$(ls -A lib)" ]; then
    rm lib/*
fi
cd nodejs
if [ "$(ls -A node*)" ]; then
    rm -rf node*
fi
rm -rf node_modules node${NODE_VERSION%%$DOT_CHAR*} package*.json ../package-lock.json
npm init -y
npm install canvas --build-from-source
npm install mocha --save-dev
jq --arg LAYER_NAME "$LAYER_NAME" --arg LAYER_DESCRIPTION "$LAYER_DESCRIPTION" --arg LAYER_VERSION "$LAYER_VERSION" --arg LAYER_AUTHOR "$LAYER_AUTHOR" --arg SEMVER_VERSION "$SEMVER_VERSION" '.name = $LAYER_NAME | .description = $LAYER_DESCRIPTION | .version = $LAYER_VERSION | .license = "MIT" | .author = $LAYER_AUTHOR | .scripts.test = "mocha" | .overrides.semver = $SEMVER_VERSION ' package.json > package-tmp.json
mv -f package-tmp.json package.json

# Test if installed modules and dependencies work fine
npm test
cp package-lock.json ..
npm rm mocha

# Prepare and package layer
mkdir node${NODE_VERSION%%$DOT_CHAR*}
mv node_modules node${NODE_VERSION%%$DOT_CHAR*}
cd ..
find nodejs/node${NODE_VERSION%%$DOT_CHAR*} -type f -name '*.node' 2>/dev/null | grep -v 'obj\.target' | xargs ldd | awk 'NF == 4 { system("cp " $3 " lib") }'
zip -q -r canvas-nodejs_v$LAYER_VERSION-node${NODE_VERSION%%$DOT_CHAR*}.zip . -x LICENSE README.md .git/**\* .github/**\* .gitignore nodejs/test/**\* *.yml build-layer.sh
