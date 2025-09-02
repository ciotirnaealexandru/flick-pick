const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Hello World!");
});

// where i declare routes
const show = require("./show/show");
const show_review = require("./show/review/review");
const user = require("./user/user");
const user_show = require("./user/show/show");
const user_show_review = require("./user/show/review/review");
const user_deck = require("./user/deck/deck");

// where i call routes
router.use("/show", show);
router.use("/show/review", show_review);
router.use("/user", user);
router.use("/user/show", user_show);
router.use("/user/show/review", user_show_review);
router.use("/user/deck", user_deck);

router.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    status: false,
    message: err.message,
  });
});
module.exports = router;
