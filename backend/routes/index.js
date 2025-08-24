const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Hello World!");
});

// where i declare routes
const user = require("./user/auth", "./user/shows");
const shows = require("./shows/shows");

// where i call routes
router.use("/user", user);
router.use("/shows", shows);

router.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    status: false,
    message: err.message,
  });
});
module.exports = router;
