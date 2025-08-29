const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");

const {
  authenticateToken,
  adminOrSelfRequired,
} = require("../../../middlewares");

// READ all the reviews of the user
router.get(
  "/:user_id/:show_id/all",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);

// CREATE a review (based on the id of the user)
router.post(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);

// READ a review (based on the id of the user)
router.get(
  "/:user_id/:show_id/:review_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);

// UPDATE a review (based on the id of the user)
router.patch(
  "/:user_id/:show_id/:review_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);

// DELETE a review by (based on the id of the user)
router.delete(
  "/:user_id/:show_id/:review_id",
  authenticateToken,
  adminOrSelfRequired,
  (req, res) => {
    // TODO
  }
);
