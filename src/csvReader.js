
const fs = require("node:fs");
const path = require("node:path");
const { parse } = require("csv-parse/sync");

function readCsv(fileName) {
    const filePath = path.join(__dirname, "../data", fileName);
    const fileContent = fs.readFileSync(filePath, "utf8");

    return parse(fileContent, {
        columns: true,
        skip_empty_lines: true,
        bom: true
    });
}

module.exports = readCsv;
