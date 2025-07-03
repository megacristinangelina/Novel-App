const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const cors = require("cors");
const createError = require("http-errors"); 
const indexRouter = require("./router"); // Pastikan file ini adalah router utama
const index = require('./index')
const app = express();

app.use(express.json());
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);

app.use(cors());

// Gunakan satu endpoint utama
app.use("/api", indexRouter);
app.use('/', index)

// Handling error
app.use((err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.message = err.message || "Internal Server Error";
  res.status(err.statusCode).json({
    message: err.message,
  });
});

app.listen(5000, () => console.log("Server Berjalan di port 5000..."));
