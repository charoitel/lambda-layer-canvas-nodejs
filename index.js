var Canvas = require('canvas');

exports.handler = function(event, context, callback) {
    var canvas = new Canvas(200, 200);
    var ctx = canvas.getContext('2d');

    ctx.font = '30px Impact';
    ctx.fillText('Awesome!', 50, 100);

    callback(null, '<img src="' + canvas.toDataURL() + '" />');
};

