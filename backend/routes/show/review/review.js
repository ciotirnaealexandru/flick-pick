const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../../middlewares");

// READ all the reviews of every user
router.get("/all", authenticateToken, adminRequired, (req, res) => {
  // TODO
});

// + CRUD
