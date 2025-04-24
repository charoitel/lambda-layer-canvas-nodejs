let { registerFont, createCanvas } = require('canvas');
let { CategoryScale, Chart, LinearScale, LineController, LineElement, PointElement } = require('chart.js');
var assert = require('assert');

describe('Chart', function () {
    describe('#drawLineGraph', function () {
        it('should draw a line graph', function () {
            Chart.register([
                CategoryScale,
                LineController,
                LineElement,
                LinearScale,
                PointElement
            ]);

            const canvas = createCanvas(400, 300);
            const chart = new Chart(
                canvas, // TypeScript needs "as any" here
                {
                    type: 'line',
                    data: {
                        labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                        datasets: [{
                            label: '# of Votes',
                            data: [12, 19, 3, 5, 2, 3],
                            borderColor: 'red'
                        }]
                    }
                }
            );
            const dataURL = canvas.toDataURL();
            // console.log(dataURL);
            chart.destroy();
        });
    })
});