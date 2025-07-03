const { check } = require("express-validator");

exports.signupValidation = [
  check("username", "Username is required").not().isEmpty(),
  check("password", "Password must be 6 or more characters").isLength({
    min: 6,
  }),
  check("email", "Please insert a valid email").isEmail(),
];

exports.loginValidation = [
  check("username", "Username is required").not().isEmpty(),
  check("password", "Password must be 6 or more characters").isLength({
    min: 6,
  }),
];
