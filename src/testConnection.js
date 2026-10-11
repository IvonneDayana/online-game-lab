
const database = require("../config/database");

async function testConnection() {
    try {
        const connection = await database.getConnection();

        console.log("Connection successful");

        connection.release();
    } catch (error) {
        console.error("Connection failed:", error.message);
    } finally {
        await database.end();
    }
}

testConnection();
