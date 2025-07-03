const express = require("express");
const router = express.Router();
const db = require("./dbConnection");
const { signupValidation, loginValidation } = require("./validation");
const { validationResult } = require("express-validator");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Register route
router.post("/register", signupValidation, (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({ errors: errors.array() });
  }

  db.query(
    `SELECT * FROM tbuser WHERE username = ${db.escape(req.body.username)}`,
    (err, result) => {
      if (err) return res.status(500).json({ message: err });

      if (result.length > 0) {
        return res
          .status(409)
          .json({ message: "The username is already exist..." });
      } else {
        bcrypt.hash(req.body.password, 10, (err, hash) => {
          if (err) return res.status(500).json({ message: err });

          db.query(
            `INSERT INTO tbuser (username, email, password) VALUES (
              ${db.escape(req.body.username)},
              ${db.escape(req.body.email)},
              ${db.escape(hash)}
            )`,
            (err, result) => {
              if (err) return res.status(400).json({ message: err });
              return res
                .status(201)
                .json({ message: "The user successfully registered..." });
            }
          );
        });
      }
    }
  );
});

// Login route
router.post("/login", loginValidation, (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({ errors: errors.array() });
  }

  db.query(
    `SELECT * FROM tbuser WHERE username = ${db.escape(req.body.username)}`,
    (err, result) => {
      if (err) return res.status(500).json({ message: err });

      if (!result.length) {
        return res.status(401).json({ message: "Username incorrect..." });
      }

      bcrypt.compare(req.body.password, result[0].password, (bErr, bResult) => {
        if (bErr) return res.status(500).json({ message: bErr });

        if (bResult) {
          const token = jwt.sign(
            { id: result[0].id },
            "the-super-strong-secret",
            { expiresIn: "1h" }
          );
          return res.status(200).json({
            message: "You successfully logged in...",
            token,
            user: result[0],
          });
        } else {
          return res.status(401).json({ message: "Password is incorrect..." });
        }
      });
    }
  );
});

// Get user info route
router.get("/get-user", (req, res) => {
  const authHeader = req.headers.authorization;

  if (
    !authHeader ||
    !authHeader.startsWith("Bearer ") ||
    !authHeader.split(" ")[1]
  ) {
    return res.status(422).json({ message: "Insert the token" });
  }

  const token = authHeader.split(" ")[1];

  let decoded;
  try {
    decoded = jwt.verify(token, "the-super-strong-secret");
  } catch (err) {
    return res.status(401).json({ message: "Invalid token" });
  }

  db.query(
    "SELECT * FROM tbuser WHERE id = ?",
    [decoded.id],
    (error, result) => {
      if (error) return res.status(500).json({ message: error });

      return res.status(200).json({
        error: false,
        data: result[0],
        message: "Fetching account is success...",
      });
    }
  );
});

module.exports = router;


