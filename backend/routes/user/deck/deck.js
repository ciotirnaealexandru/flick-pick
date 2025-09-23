const express = require("express");
const router = express.Router();
const prisma = require("../../../prismaClient");

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../../middlewares");

// READ all the decks of the user
router.get(
  "/all/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const decks = await prisma.deck.findMany({
        where: {
          userId: parseInt(req.params.user_id),
        },
        include: {
          userShows: {
            include: {
              show: true,
            },
            orderBy: { updatedAt: "asc" },
          },
        },
      });

      res.status(200).json(decks);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

router.post(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { deckName } = req.body;

      if (deckName == null)
        return res.status(404).json({ message: "Deck name is required." });

      // check if the deck already exists in the database
      const deck = await prisma.deck.findUnique({
        where: {
          name_userId: {
            name: deckName,
            userId: parseInt(req.params.user_id),
          },
        },
      });

      if (deck)
        return res.status(404).json({ message: "Deck already exists." });

      const newDeck = await prisma.deck.create({
        data: {
          name: deckName,
          userId: parseInt(req.params.user_id),
        },
      });

      res.status(200).json(newDeck);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// READ a certain deck of the user
router.get(
  "/:user_id/:deck_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const deck = await prisma.deck.findUnique({
        where: {
          id: parseInt(req.params.deck_id),
        },
        include: {
          userShows: {
            include: {
              show: true,
            },
          },
        },
      });

      if (!deck) return res.status(404).json({ message: "Deck not found." });

      res.status(200).json(deck);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// UPDATE a certain deck of the user
router.patch(
  "/:user_id/:deck_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { deckName } = req.body;

      if (!deckName)
        return res.status(404).json({ message: "Deck name is required." });

      const existingDeck = await prisma.deck.findUnique({
        where: {
          name_userId: {
            name: deckName,
            userId: parseInt(req.params.user_id),
          },
        },
      });

      if (existingDeck != null)
        return res.status(500).json({ message: "Deck name already in use." });

      const deck = await prisma.deck.upsert({
        where: {
          id: parseInt(req.params.deck_id),
        },
        update: {
          name: deckName,
        },
        create: {
          name: deckName,
          userId: parseInt(req.params.user_id),
        },
        include: {
          userShows: {
            include: {
              show: true,
            },
          },
        },
      });

      if (!deck) return res.status(404).json({ message: "Deck not found." });

      res.status(200).json(deck);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// DELETE a certain deck
router.delete(
  "/:user_id/:deck_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const deck = await prisma.deck.findUnique({
        where: {
          id: parseInt(req.params.deck_id),
        },
        include: {
          userShows: true,
        },
      });

      if (!deck) return res.status(404).json({ message: "Deck not found." });

      await prisma.userShow.deleteMany({
        where: {
          userId: parseInt(req.params.user_id),
          decks: {
            some: {
              id: parseInt(req.params.deck_id),
            },
          },
        },
      });

      // delete the deck
      await prisma.deck.delete({
        where: {
          id: parseInt(req.params.deck_id),
        },
      });

      res.status(200).json({ message: "Deck successfully deleted." });
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

module.exports = router;
