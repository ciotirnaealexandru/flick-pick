const express = require("express");
const router = express.Router();

// HELLO!
router.get("/", (req, res) => {
  res.send("Hello!");
});

module.exports = router;
