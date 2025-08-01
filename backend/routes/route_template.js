const express = require("express");
const router = express.Router();

// HELLO!
router.get("/", (req, res) => {
  res.send("Hello!");
});

// define the about route
router.get("/about", (req, res) => {
  res.send("About page");
});

module.exports = router;
