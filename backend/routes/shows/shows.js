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
router.get("/:id", async (req, res) => {
  try {
    const response = await fetch(
      `https://api.tvmaze.com/shows/${req.params.id}`
    );
    const data = await response.json();

    // get only the fields i like
    const simplified = {
      id: data.id,
      name: data.name,
      genres: data.genres,
      image: data.image?.medium,
      summary: stripHTMLTags(data.summary),
      premiered: getYear(data.premiered),
      ended: getYear(data.ended),
    };

    res.json(simplified);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch show" });
  }
});

// gets info about the seasons of a show by its id
router.get("/:id/seasons", async (req, res) => {
  try {
    const response = await fetch(
      `https://api.tvmaze.com/shows/${req.params.id}/seasons`
    );
    const data = await response.json();

    const simplified = data.map((data) => ({
      id: data.id,
      number: data.number,
      name: data.name,
      episodeOrder: data.episodeOrder,
      image: data.image?.medium,
      summary: data.summary,
    }));

    res.json(simplified);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch seasons" });
  }
});

module.exports = router;
