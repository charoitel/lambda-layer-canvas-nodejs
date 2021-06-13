cd nodejs
rm -rf node_modules package*.json
npm init -y
npm install canvas --build-from-source
npm install mocha --save-dev
CANVAS_VERSION=$(jq -r '.dependencies.canvas[1:]' package.json)
jq --arg CANVAS_VERSION "$CANVAS_VERSION" '.name = "canvas-nodejs" | .version = $CANVAS_VERSION | .license = "MIT" | .author = "Charoite Lee" | .scripts.test = "mocha"' package.json > package-tmp.json
mv -f package-tmp.json package.json
npm test
cp package-lock.json ..
cd ..
rm canvas-nodejs_v$CANVAS_VERSION.zip
zip -q -r canvas-nodejs_v$CANVAS_VERSION.zip . -x "LICENSE" "README.md" ".git*" "nodejs/test/*" "*.yml" "build-layer.sh"
