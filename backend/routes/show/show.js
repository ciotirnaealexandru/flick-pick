const express = require("express");
const router = express.Router();

// this is used to strip HTML formatting from things like show summaries
const stripHTMLTags = require("../../helpers/stripHTMLTags");
const getYear = require("../../helpers/getYear");

const prisma = require("../../prismaClient");

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../middlewares");

// gets a list of the default popular shows from the API
router.get("/popular", async (req, res) => {
  try {
    const response = await fetch("https://api.tvmaze.com/shows");
    const data = await response.json();

    // get only the fields i like
    const simplified = data.map((show) => ({
      apiId: show.id,
      name: show.name,
      imageUrl: show.image?.medium,
      summary: show.summary,
    }));

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

// gets a list of 10 (this is the default of the API)
router.get("/search/:name", async (req, res) => {
  try {
    const parsedName = encodeURIComponent(req.params.name);
    const response = await fetch(
      `https://api.tvmaze.com/search/shows?q=${parsedName}`
    );
    const data = await response.json();

    // get only the fields i like
    const simplified = data.map((show) => ({
      apiId: show.show.id,
      name: show.show.name,
      imageUrl: show.show.image?.medium,
      summary: show.show.summary,
    }));

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

// gets specific info of a show by api id
router.get("/more/:api_id", async (req, res) => {
  try {
    // get the main show info
    const showsIdResponse = await fetch(
      `https://api.tvmaze.com/shows/${req.params.api_id}`
    );
    const mainData = await showsIdResponse.json();

    const networkName =
      mainData.network?.name ?? mainData.webChannel?.name ?? "Unknown Network";
    const endingYear =
      mainData.status === "Ended" ? getYear(mainData.ended) : "2025";

    // get the seasons info
    const seasonsResponse = await fetch(
      `https://api.tvmaze.com/shows/${req.params.api_id}/seasons`
    );
    const seasonsData = await seasonsResponse.json();

    // get only the seasons info that i like
    const seasonsArray = Array.isArray(seasonsData) ? seasonsData : [];
    const seasonsInfo = seasonsArray.map((seasonsData) => ({
      id: seasonsData.id,
      number: seasonsData.number,
      name: seasonsData.name,
      imageUrl: seasonsData.image?.medium,
      summary: stripHTMLTags(seasonsData.summary),
      episodeOrder: seasonsData.episodeOrder,
    }));

    // get only the show info that i like
    const showInfo = {
      apiId: mainData.id,
      name: mainData.name,
      imageUrl: mainData.image?.medium,
      summary: stripHTMLTags(mainData.summary),
      genres: mainData.genres,
      premiered: getYear(mainData.premiered),
      ended: endingYear,
      network: networkName,
      seasonsInfo: seasonsInfo,
    };

    res.status(200).json(showInfo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch show." });
  }
});

module.exports = router;
