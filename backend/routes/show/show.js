const express = require("express");
const router = express.Router();

// this is used to strip HTML formatting from things like show summaries
const stripHTMLTags = require("../../helpers/stripHTMLTags");
const getYear = require("../../helpers/getYear");

// gets a list of the default popular shows from the API
router.get("/popular", async (req, res) => {
  try {
    const response = await fetch("https://api.tvmaze.com/shows");
    const data = await response.json();

    // get only the fields i like
    const simplified = data.map((show) => ({
      id: show.id,
      name: show.name,
      genres: show.genres,
      image: show.image?.medium,
      summary: show.summary,
    }));

    res.json(simplified);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch shows" });
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
      id: show.show.id,
      name: show.show.name,
      genres: show.show.genres,
      image: show.show.image?.medium,
      summary: show.show.summary,
    }));

    res.json(simplified);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch shows" });
  }
});

// gets specific info of a show by id
router.get("/:show_id", async (req, res) => {
  try {
    // get the main show info
    const showsIdResponse = await fetch(
      `https://api.tvmaze.com/shows/${req.params.show_id}`
    );
    const mainData = await showsIdResponse.json();

    const networkName =
      mainData.network?.name ?? mainData.webChannel?.name ?? "Unknown Network";
    const endingYear =
      mainData.status === "Ended" ? getYear(mainData.ended) : "Present";

    // get the seasons info
    const seasonsResponse = await fetch(
      `https://api.tvmaze.com/shows/${req.params.show_id}/seasons`
    );
    const seasonsData = await seasonsResponse.json();

    // get only the seasons info that i like
    const seasonsInfo = seasonsData.map((seasonsData) => ({
      id: seasonsData.id,
      number: seasonsData.number,
      name: seasonsData.name,
      episodeOrder: seasonsData.episodeOrder,
      image: seasonsData.image?.medium,
      summary: seasonsData.summary,
    }));

    // get only the show info that i like
    const showInfo = {
      id: mainData.id,
      name: mainData.name,
      genres: mainData.genres,
      image: mainData.image?.medium,
      summary: stripHTMLTags(mainData.summary),
      premiered: getYear(mainData.premiered),
      ended: endingYear,
      network: networkName,
      seasonsInfo: seasonsInfo,
    };

    res.json(showInfo);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch show" });
  }
});

module.exports = router;
