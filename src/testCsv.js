
const readCsv = require("./csvReader");

const genres = readCsv("Genero.csv");

console.log("Total genres:", genres.length);
console.log("First genre:", genres[0]);
