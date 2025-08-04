const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Hello World!");
});

// where i declare routes
const auth = require("./auth");
const shows = require("./shows");

// where i call routes
router.use("/auth", auth);
router.use("/shows", shows);

router.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    status: false,
    message: err.message,
  });
});
module.exports = router;
