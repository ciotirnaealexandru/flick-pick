const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../../middlewares");

// READ all the shows of the user
router.get("/all", authenticateToken, adminOrSelfRequired, (req, res) => {
  // TODO
});

// READ all the watched shows of the user
router.get("/watched", authenticateToken, adminOrSelfRequired, (req, res) => {
  // TODO
});

// READ all the shows the user will watch
router.get(
  "/will_watch",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);

// CREATE a show the user added
router.post(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    const { apiId, name, summary, imageUrl, watchStatus } = req.body;
    // TODO
  }
);

// READ a show the user added (based on the id of the user)
router.get(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    const { apiId, name, summary, imageUrl, watchStatus } = req.body;
    // TODO
  }
);

// UPDATE a show the user added (based on the id of the user)
router.patch(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    const { apiId, name, summary, imageUrl, watchStatus } = req.body;
    // TODO
  }
);

// DELETE a show of an user (based on the id of the user)
router.delete(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    const { apiId, name, summary, imageUrl, watchStatus } = req.body;
    // TODO
  }
);
