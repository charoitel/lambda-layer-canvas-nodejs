set -e

# Remove packaged layer if exists
if [ -n "$(find . -name 'canvas-nodejs_v*.zip')" ]; then
    rm canvas-nodejs_v*.zip
fi

# Clean and prepare Node.js modules and dependencies
if [ "$(ls -A lib)" ]; then
    rm lib/*
fi
cd nodejs
rm -rf node_modules package*.json
npm init -y
npm install canvas --build-from-source
npm install mocha --save-dev
CANVAS_VERSION=$(jq -r '.dependencies.canvas[1:]' package.json)
jq --arg CANVAS_VERSION "$CANVAS_VERSION" '.name = "canvas-nodejs" | .version = $CANVAS_VERSION | .license = "MIT" | .author = "Charoite Lee" | .scripts.test = "mocha"' package.json > package-tmp.json
mv -f package-tmp.json package.json

# Test if installed modules and dependencies work fine
npm test
cp package-lock.json ..

# Prepare and package layer
cd ..
find nodejs/node_modules -type f -name '*.node' 2>/dev/null | grep -v 'obj\.target' | xargs ldd | awk 'NF == 4 { system("cp " $3 " lib") }'
zip -q -r canvas-nodejs_v$CANVAS_VERSION.zip . -x LICENSE README.md .git/**\* nodejs/test/**\* *.yml build-layer.sh
