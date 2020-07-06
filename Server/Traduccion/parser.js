var fs = require('fs');
var parser = require('./traductor');
fs.readFile('./prueba.txt',(err,data)=>{
if (err) throw err;
parser.parse(data.toString());
});