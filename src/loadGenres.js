
const database = require("../config/database");
const readCsv = require("./csvReader");

async function loadGenres() {
    try {
        const genres = readCsv("Genero.csv");

        for (const genre of genres) {
            await database.execute(
                `INSERT INTO genre (genre_id, genre_name)
                 VALUES (?, ?)`,
                [Number(genre.id_genero), genre.nombre_genero]
            );
        }

        console.log("Genres loaded:", genres.length);
    } catch (error) {
        console.error("Error loading genres:", error.message);
        process.exitCode = 1;
    } finally {
        await database.end();
    }
}

loadGenres();