const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");
const { WatchStatus } = require("@prisma/client");

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../../middlewares");

// READ all the shows of the user
router.get(
  "/all/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const shows = await prisma.userShow.findMany({
        where: {
          userId: parseInt(req.params.user_id),
        },
      });

      res.json(shows);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ all the watched shows of the user
router.get(
  "/watched/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const shows = await prisma.userShow.findMany({
        where: {
          userId: parseInt(req.params.user_id),
          watchStatus: WatchStatus.WATCHED,
        },
      });

      res.json(shows);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ all the shows the user will watch
router.get(
  "/will_watch/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const shows = await prisma.userShow.findMany({
        where: {
          userId: parseInt(req.params.user_id),
          watchStatus: WatchStatus.WILL_WATCH,
        },
      });

      res.json(shows);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// CREATE a show the user added
router.post(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { apiId, userRating, watchStatus } = req.body;

      if (!apiId) res.status(500).json({ message: "Api Id is required." });

      // check if the show already exists in my database
      // if not, add it
      const show = await prisma.show.upsert({
        where: {
          apiId: apiId,
        },
        update: {},
        create: {
          apiId: apiId,
        },
      });

      const userShow = await prisma.userShow.upsert({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: show.id,
          },
        },
        update: {
          userRating: userRating,
          watchStatus: watchStatus,
        },
        create: {
          userId: parseInt(req.params.user_id),
          showId: show.id,
          userRating: userRating,
          watchStatus: watchStatus,
        },
      });

      res.status(201).json(userShow);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ a show the user added (based on the id of the user)
router.get(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { showId } = req.body;

      if (!showId) res.status(500).json({ message: "Show Id is required." });

      // check if the user_show exists
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: showId,
          },
        },
      });

      res.status(201).json(userShow);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// DELETE a show of an user (based on the id of the user)
router.delete(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { showId } = req.body;

      if (!showId) res.status(500).json({ message: "Show Id is required." });

      // check if the user_show exists, if so, delete it
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: showId,
          },
        },
      });

      if (!userShow) {
        return res.status(404).json({ message: "User show does not exist." });
      }

      await prisma.userShow.delete({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: showId,
          },
        },
      });

      res.status(201).json({ message: "User show deleted." });
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

module.exports = router;
