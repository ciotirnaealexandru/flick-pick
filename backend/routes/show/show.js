const { error } = require("console");
const express = require("express");
const router = express.Router();

router.get("/search/name/:name", async (req, res) => {
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
        premiered: show.first_air_date,
      };
    });

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

router.get("/search/genre/:genre_id", async (req, res) => {
  try {
    let genre;
    if (req.params.genre_id == 0) {
      genre = "";
    } else {
      genre = `&with_genres=${req.params.genre_id}`;
    }

    const requests = [];

    for (let i = 1; i <= 2; i++) {
      requests.push(
        fetch(
          `https://api.themoviedb.org/3/discover/tv?include_adult=false&include_null_first_air_dates=false&language=en-US&page=${i}&sort_by=popularity.desc${genre}`,
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
        premiered: show.first_air_date,
      };
    });

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

router.get("/genres", async (req, res) => {
  try {
    const response = await fetch(
      `https://api.themoviedb.org/3/genre/tv/list?language=en`,
      {
        headers: {
          Authorization: `Bearer ${process.env.API_READ_ACCESS_TOKEN}`,
          accept: "application/json",
        },
      }
    );

    const data = await response.json();

    const simplified = data.genres.map((genre) => {
      return {
        genreId: genre.id,
        genreName: genre.name,
      };
    });

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch genres." });
  }
});

// gets specific info of a show by api id
router.get("/details/:api_id", async (req, res) => {
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
      premiered: mainData.first_air_date,
      ended: mainData.last_air_date,
      network: networkName,
    };

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch show." });
  }
});

router.get("/similar/:api_id", async (req, res) => {
  try {
    const response = await fetch(
      `https://api.themoviedb.org/3/tv/${req.params.api_id}/similar`,
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
        premiered: show.first_air_date,
      };
    });

    res.status(200).json(simplified);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch shows." });
  }
});

module.exports = router;
