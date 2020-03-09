const { createCanvas, registerFont } = require('canvas');

exports.handler = function(event, context, callback) {
    registerFont(__dirname + '/fonts/NotoSans-Regular.ttf', { family: 'Noto Sans' });
    var canvas = createCanvas(200, 200);
    var ctx = canvas.getContext('2d');

    ctx.font = '30px Noto Sans';
    ctx.fillText(typeof event.text !== 'undefined' ? event.text : 'Hello' , 50, 100);

    callback(null, '<img src="' + canvas.toDataURL() + '" />');
};

