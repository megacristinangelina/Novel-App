const mysql = require("mysql");
const conn = mysql.createConnection({
  connectionLimit: 10,
  host: "localhost",
  user: "root",
  password: "",
  database: "dbnovel",
});

conn.connect(function (err) {
  if (err) throw err;
  console.log("Database is connected succesfully");
});
module.exports = conn;
