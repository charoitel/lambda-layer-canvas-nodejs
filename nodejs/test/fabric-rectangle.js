let fabric = require('fabric').fabric;
var assert = require('assert');

describe('Canvas', function() {
    describe('#drawRectangle', function() {
      it('should draw a red rectangle', function() {
        var rect = new fabric.Rect({
          left: 100,
          top: 100,
          fill: 'red',
          width: 20,
          height: 20
        });
        rect.toSVG();
      });
    })
});