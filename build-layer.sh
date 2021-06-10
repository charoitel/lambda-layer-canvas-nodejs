cd nodejs
rm -rf node_modules package*.json
npm init -y
npm install canvas --build-from-source
npm install mocha --save-dev
cp package-lock.json ..
cd ..
rm ../canvas-nodejs_v2.8.0.zip
zip -r ../canvas-nodejs_v2.8.0.zip . -x "LICENSE" "README.md" ".git*" "nodejs/test/*" "*.yml" "build-layer.sh"
