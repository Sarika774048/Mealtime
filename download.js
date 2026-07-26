const https = require('https');
const fs = require('fs');

const url = 'https://wpzone.co/wp-content/uploads/2020/12/Divi-Shop-Module-Cart-page-demo.jpg';
const file = fs.createWriteStream('ref_cart.jpg');

https.get(url, (res) => {
    res.pipe(file);
    file.on('finish', () => {
        file.close(() => {
            console.log('Download complete, size:', fs.statSync('ref_cart.jpg').size);
        });
    });
}).on('error', (err) => {
    console.error('Error:', err.message);
});
