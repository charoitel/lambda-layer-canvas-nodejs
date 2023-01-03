let { registerFont, createCanvas } = require('canvas');
var assert = require('assert');

describe('Font', function() {
  describe('#registerFont', function() {
    it('should register defined Font by name', function() {
      registerFont('/usr/share/fonts/dejavu-sans-fonts/DejaVuSans.ttf', { family: 'DejaVu Sans' });
    });
  }),
  describe('#fillText', function() {
    it('should write defined Text in canvas', function() {
      registerFont('/usr/share/fonts/dejavu-sans-fonts/DejaVuSans-Bold.ttf', { family: 'DejaVu Sans Bold' });
      let canvas = createCanvas(300, 300);
      let ctx1 = canvas.getContext('2d');
      ctx1.font = '30px';
      ctx1.fillText('Default', 5, 15);
      let ctx2 = canvas.getContext('2d');
      ctx2.font = '30px "DejaVu Sans"';
      ctx2.fillText('DejaVu Sans', 5, 45);
      let ctx3 = canvas.getContext('2d');
      ctx3.font = '30px "DejaVu Sans Bold"';
      ctx3.fillText('DejaVu Sans Bold', 5, 75);
      console.log(canvas.toDataURL());
    })
  });
});
