
const database = require("../config/database");
const readCsv = require("./csvReader");

const tables = [
    {
        file: "Genero.csv",
        table: "genre",
        columns: ["genre_id", "genre_name"],
        fields: ["id_genero", "nombre_genero"]
    },
    {
        file: "Plataforma.csv",
        table: "platform",
        columns: ["platform_id", "platform_name"],
        fields: ["id_plataforma", "nombre_plataforma"]
    },
    {
        file: "Publisher.csv",
        table: "publisher",
        columns: ["publisher_id", "publisher_name"],
        fields: ["id_publisher", "nombre_publisher"]
    },
    {
        file: "Juego.csv",
        table: "game",
        columns: ["game_id", "game_name"],
        fields: ["id_juego", "nombre_juego"]
    },
    {
        file: "Publicacion_Final.csv",
        table: "game_release",
        columns: [
            "release_id", "game_id", "platform_id", "genre_id",
            "publisher_id", "release_year", "na_sales",
            "eu_sales", "jp_sales", "other_sales", "global_sales"
        ],
        fields: [
            "id_publicacion", "id_juego", "id_plataforma",
            "id_genero", "id_publisher", "anio", "ventas_na",
            "ventas_eu", "ventas_jp", "ventas_otras",
            "ventas_globales"
        ]
    }
];

function convertValue(value) {
    if (value === undefined || value === null || value.trim() === "") {
        return null;
    }

    return value;
}

function validateNumber(value, column) {
    if (value === null) {
        return;
    }

    const number = Number(value);

    if (!Number.isFinite(number)) {
        throw new Error(`Invalid number in ${column}`);
    }

    if (number < 0) {
        throw new Error(`Negative value in ${column}`);
    }
    
    if (
        (column.endsWith("_id") || column === "release_year") &&
        !Number.isInteger(number)
    ) {
        throw new Error(`Invalid integer in ${column}`);
    }
    
    if (column.endsWith("_id") && number === 0) {
        throw new Error(`Invalid ID in ${column}`);
    }
    
    const idLimits = {
        genre_id: 255,
        platform_id: 255,
        publisher_id: 65535,
        game_id: 4294967295,
        release_id: 4294967295
    };

    if (column in idLimits && number > idLimits[column]) {
        throw new Error(`ID too large in ${column}`);
    }


    if (column === "release_year" && number > 9999) {
        throw new Error(`Invalid year in ${column}`);
    }

    if (column.endsWith("_sales") && number > 9999.99) {
        throw new Error(`Sales value too large in ${column}`);
    }
    
    if (column.endsWith("_sales") && !/^\d+(\.\d{1,2})?$/.test(value)) {
        throw new Error(`Invalid sales format in ${column}`);
    }



}

async function loadTable(connection, config) {
    
    const records = readCsv(config.file);

    const placeholders = config.columns.map(() => "?").join(", ");
    const columnNames = config.columns.join(", ");

    const query = `INSERT INTO ${config.table} (${columnNames})
                   VALUES (${placeholders})`;

    let count = 0;

    for (const record of records) {
        const values = config.fields.map(field => convertValue(record[field]));
        
        values.forEach((value, index) => {
            const column = config.columns[index];

            if (
                column.endsWith("_id") ||
                column === "release_year" ||
                column.endsWith("_sales")
            ) {
                validateNumber(value, column);
            }
        });


        if (values.some((value, index) =>
            value === null && !["publisher_id", "release_year"].includes(config.columns[index])
        )) {
            throw new Error(`Invalid data in ${config.file}, record ${count + 1}`);
        }

        await connection.execute(query, values);
        count++;
    }

    console.log(`${config.table}: ${count} records loaded`);
}

async function main() {
    let connection;

    try {
        connection = await database.getConnection();
        await connection.beginTransaction();
        
        for (const config of tables) {
            const [rows] = await connection.query(
                `SELECT COUNT(*) AS total FROM ${config.table}`
            );

            if (rows[0].total > 0) {
                throw new Error(`${config.table} already contains data`);
            }
        }


        for (const config of tables) {
            await loadTable(connection, config);
        }

        await connection.commit();
        console.log("Data loading completed");

    } catch (error) {
        if (connection) {
            await connection.rollback();
        }

        console.error("Loading failed:", error.message);
        process.exitCode = 1;

    } finally {
        if (connection) {
            connection.release();
        }

        await database.end();
    }
}

main();
