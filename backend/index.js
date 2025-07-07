const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const { json } = require("body-parser");
const app = express();
const port = process.env.PORT || 5000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//MySQL Connection
const pool = mysql.createPool({
  connectionLimit: 10,
  host: "localhost",
  user: "root",
  password: "",
  database: "dbnovel",
});

//Add data to novels
app.post("/novel_type", (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    console.log(`connected as id ${connection.threadId}`);

    const params = req.body;
    connection.query("insert into novels set ?", params, (err, rows) => {
      connection.release();

      if (!err) {
        res.send({
          message: `Item Type with the name ${params.title} successfully saved...`,
        });
      } else {
        console.log("gagal", err);
      }
    });
  });
});

//mengambil data dari novels
app.get("/novel_type", (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    console.log("connected as id ${connection.threadId}");
    connection.query("select * from novels", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }
    });
  });
});

//GET data novels by id
app.get("/novel_type/:id", (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    console.log(`connected as id ${connection.threadId}`);

    connection.query(
      "SELECT * FROM novels where id = ?",
      [req.params.id],
      (err, rows) => {
        connection.release();

        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
      }
    );
  });
});

//update data novels
app.put("/novel_type/:id", (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    console.log(`connected as id ${connection.threadId}`);

    const params = req.body;
    connection.query(
      "UPDATE novels set ? where id = ?",
      [params, req.params.id],
      (err, rows) => {
        connection.release();

        if (!err) {
          res.end(
            JSON.stringify({ message: "Item Type Successfully updated..." })
          );
        } else {
          res.end(
            JSON.stringify({ message: "Item Type Unsuccessfully updated..." })
          );
          console.log(err);
        }
      }
    );
  });
});

//DELETE data tbtype by id
app.delete("/novel_type/:id", (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    console.log(`connected as id ${connection.threadId}`);

    connection.query(
      "DELETE from novels where id = ?",
      [req.params.id],
      (err, rows) => {
        connection.release();

        if (!err) {
          res.end(
            JSON.stringify({ message: "Item Type Successfully deleted..." })
          );
        } else {
          res.end(
            JSON.stringify({ message: "Item Type Unsuccessfully deleted..." })
          );
          console.log(err);
        }
      }
    );
  });
});


// // //Listen on environtment port or 5000
// app.listen(port, () => {
//   console.log(`Listen on port ${port}`);
// });

module.exports = app;