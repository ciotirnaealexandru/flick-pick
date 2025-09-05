const express = require("express");
const router = express.Router();

// this is used to strip HTML formatting from things like show summaries
const getYear = require("../../helpers/getYear");

// gets a list of the default popular shows from the API
router.get("/popular", async (req, res) => {
  try {
    const requests = [];

    for (let i = 1; i <= 3; i++) {
      requests.push(
        fetch(
          `https://api.themoviedb.org/3/tv/popular?include_adult=false&language=en-US&page=${i}`,
          {
            headers: {
              Authorization: `Bearer ${process.env.API_READ_ACCESS_TOKEN}`,
              accept: "application/json",
            },
          }
        ).then((res) => res.json())
      );
    }

    const data = await Promise.all(requests);
    const allResults = data.flatMap((page) => page.results);

    const baseUrl = "https://image.tmdb.org/t/p/";
    const size = "w185";

    // get only the fields i like
    const simplified = allResults.map((show) => {
      const posterPath = show.poster_path;
      const fullPosterUrl = posterPath
        ? `${baseUrl}${size}${posterPath}`
        : null;

      return {
        apiId: show.id,
        name: show.name,
        imageUrl: fullPosterUrl,
        summary: show.overview,
      };
    });

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

router.get("/search/:name", async (req, res) => {
  try {
    const parsedName = encodeURIComponent(req.params.name);

    const response = await fetch(
      `https://api.themoviedb.org/3/search/tv?include_adult=false&language=en-US&page=1&query=${parsedName}`,
      {
        headers: {
          Authorization: `Bearer ${process.env.API_READ_ACCESS_TOKEN}`,
          accept: "application/json",
        },
      }
    );

    const data = await response.json();

    const baseUrl = "https://image.tmdb.org/t/p/";
    const size = "w185";

    // get only the fields i like
    const simplified = data.results.map((show) => {
      const posterPath = show.poster_path;
      const fullPosterUrl = posterPath
        ? `${baseUrl}${size}${posterPath}`
        : null;

      return {
        apiId: show.id,
        name: show.name,
        imageUrl: fullPosterUrl,
        summary: show.overview,
      };
    });

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
      `https://api.themoviedb.org/3/tv/${req.params.api_id}?language=en-US`,
      {
        headers: {
          Authorization: `Bearer ${process.env.API_READ_ACCESS_TOKEN}`,
          accept: "application/json",
        },
      }
    );

    const mainData = await showsIdResponse.json();

    const networkName = mainData.networks?.[0]?.name ?? "Unknown Network";
    const baseUrl = "https://image.tmdb.org/t/p/";
    const size = "w185";

    const posterPath = mainData.poster_path;
    const fullPosterUrl = posterPath ? `${baseUrl}${size}${posterPath}` : null;

    const simplified = {
      apiId: mainData.id,
      name: mainData.name,
      imageUrl: fullPosterUrl,
      summary: mainData.overview,
      genres: mainData.genres?.map((g) => g.name) || [],
      premiered: getYear(mainData.first_air_date),
      ended: getYear(mainData.last_air_date),
      network: networkName,
    };

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch show." });
  }
});

module.exports = router;
