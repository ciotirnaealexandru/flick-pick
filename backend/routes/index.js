const express = require("express");
const router = express.Router();
const createError = require("http-errors");

//const auth = require("./auth");

router.get("/", (req, res) => {
  res.send("Hello World!");
});

/*router.use("/auth", auth);
router.use(async (req, res, next) => {
  next(createError.NotFound("Route not Found"));
});*/

router.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    status: false,
    message: err.message,
  });
});
module.exports = router;
