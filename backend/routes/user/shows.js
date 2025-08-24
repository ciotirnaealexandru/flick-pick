const express = require("express");
const router = express.Router();
const prisma = require("../../prismaClient");

// get all the shows of the user
router.get("/shows", authenticateToken, (req, res) => {
  // TODO
});

// get all the watched shows of the user
router.get("/shows/watched", authenticateToken, (req, res) => {
  // TODO
});

// get all the shows the user will watch
router.get("/shows/will_watch", authenticateToken, (req, res) => {
  // TODO
});

// post a show the user added (with it's watch status, by default WILL_WATCH)
router.post("/show", authenticateToken, (req, res) => {
  const { apiId, name, summary, imageUrl, watchStatus } = req.body;
  // TODO
});

// update a show the user added
router.patch("/show", authenticateToken, (req, res) => {
  const { apiId, name, summary, imageUrl, watchStatus } = req.body;
  // TODO
});
