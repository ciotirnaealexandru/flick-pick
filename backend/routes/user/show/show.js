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
          decks: true,
        },
        orderBy: { updatedAt: "asc" },
      });

      res.status(200).json(shows);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// RATE a show
router.post(
  "/rate/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { userRating } = req.body;

      if (userRating == null)
        return res.status(404).json({ message: "User rating is required." });

      // get the show from the api id
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: parseInt(req.params.show_id),
          },
        },
      });

      if (!userShow)
        return res.status(404).json({ message: "User show does not exist." });

      // change the rating of the user show
      const ratedUserShow = await prisma.userShow.update({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: parseInt(req.params.show_id),
          },
        },
        data: {
          userRating: userRating,
        },
        include: {
          show: true,
          decks: true,
        },
      });

      res.status(200).json(ratedUserShow);
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
      const { apiId, name, imageUrl, summary, premiered, selectedDeckIds } =
        req.body;

      if (apiId == null)
        return res.status(404).json({ message: "Api Id is required." });

      if (name == null)
        return res.status(404).json({ message: "Name is required." });

      if (imageUrl == null)
        return res.status(404).json({ message: "ImageUrl is required." });

      if (summary == null)
        return res.status(404).json({ message: "Summary is required." });

      if (premiered == null)
        return res.status(404).json({ message: "Premiered is required." });

      if (selectedDeckIds == null || !Array.isArray(selectedDeckIds))
        return res.status(404).json({ message: "Decks are required." });

      // check if the show already exists in my database
      // if not, add it
      const show = await prisma.show.upsert({
        where: {
          apiId: parseInt(apiId),
        },
        update: {
          name: name,
          imageUrl: imageUrl,
          summary: summary,
          premiered: premiered,
        },
        create: {
          apiId: parseInt(apiId),
          name: name,
          imageUrl: imageUrl,
          summary: summary,
          premiered: premiered,
        },
      });

      const decksInt = selectedDeckIds.map((id) => parseInt(id));

      // check if all decks exist
      const existingDecks = await prisma.deck.findMany({
        where: {
          id: { in: decksInt },
        },
      });

      if (existingDecks.length !== decksInt.length) {
        return res
          .status(404)
          .json({ message: "One or more decks not found." });
      }

      /* add the show for the user */

      // get current user show if it exists
      const currentUserShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: show.id,
          },
        },
        include: { decks: true },
      });

      const currentDeckIds = currentUserShow?.decks.map((d) => d.id) || [];

      // decks to connect (new in request, not already linked)
      const connectDecks = decksInt
        .filter((id) => !currentDeckIds.includes(id))
        .map((id) => ({ id }));

      // decks to disconnect (linked but not in new request)
      const disconnectDecks = currentDeckIds
        .filter((id) => !decksInt.includes(id))
        .map((id) => ({ id }));

      const userShow = await prisma.userShow.upsert({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: show.id,
          },
        },
        update: {
          decks: {
            connect: connectDecks,
            disconnect: disconnectDecks,
          },
        },
        create: {
          userId: parseInt(req.params.user_id),
          showId: show.id,
          decks: {
            connect: decksInt.map((id) => ({ id })),
          },
        },
        include: {
          show: true,
          decks: true,
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
        include: {
          decks: true,
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

// DELETE a show of an user
router.delete(
  "/:user_id/:show_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const userShow = await prisma.userShow.findUnique({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: parseInt(req.params.show_id),
          },
        },
      });

      if (!userShow)
        return res.status(404).json({ message: "User show does not exist." });

      await prisma.userShow.delete({
        where: {
          userId_showId: {
            userId: parseInt(req.params.user_id),
            showId: parseInt(req.params.show_id),
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
