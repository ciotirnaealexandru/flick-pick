const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");
const { WatchStatus } = require("@prisma/client");

const stripHTMLTags = require("../../../helpers/stripHTMLTags");

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
        include: {
          show: true,
        },
      });

      res.status(200).json(shows);
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
        include: {
          show: true,
        },
      });

      res.status(200).json(shows);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ all the shows the user will watch
router.get(
  "/future/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const shows = await prisma.userShow.findMany({
        where: {
          userId: parseInt(req.params.user_id),
          watchStatus: WatchStatus.FUTURE,
        },
        include: {
          show: true,
        },
      });

      res.status(200).json(shows);
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
      const { apiId, name, imageUrl, summary, userRating, watchStatus } =
        req.body;

      if (!apiId)
        return res.status(500).json({ message: "Api Id is required." });

      if (!name) return res.status(500).json({ message: "Name is required." });

      if (!imageUrl)
        return res.status(500).json({ message: "ImageUrl is required." });

      if (!summary)
        return res.status(500).json({ message: "Summary is required." });

      // check if the show already exists in my database
      // if not, add it
      const show = await prisma.show.upsert({
        where: {
          apiId: parseInt(apiId),
        },
        update: {
          name: name,
          imageUrl: imageUrl,
          summary: stripHTMLTags(summary),
        },
        create: {
          apiId: parseInt(apiId),
          name: name,
          imageUrl: imageUrl,
          summary: stripHTMLTags(summary),
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
        include: {
          show: true,
        },
      });

      res.status(200).json(userShow);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ a show (return only main info if the user did not add it)
router.get(
  "/:user_id/:api_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      // get the show from the api id
      const show = await prisma.show.findUnique({
        where: {
          apiId: parseInt(req.params.api_id),
        },
      });

      if (!show)
        return res.status(404).json({ message: "Show does not exist." });

      // check if the user_show exists
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: show.id,
          },
        },
      });

      // if the user does not have that show return an empty json to later
      // concatenate to show info from the api
      if (!userShow) return res.status(200).json({});

      res.status(200).json(userShow);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// DELETE a show of an user (based on the id of the user)
router.delete(
  "/:user_id/:api_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      // get the show from the api id
      const show = await prisma.show.findUnique({
        where: {
          apiId: parseInt(req.params.api_id),
        },
      });

      if (!show)
        return res.status(404).json({ message: "Show does not exist." });

      // check if the user_show exists, if so, delete it
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: show.id,
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
            showId: show.id,
          },
        },
      });

      res.status(200).json({ message: "User show deleted." });
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

module.exports = router;
