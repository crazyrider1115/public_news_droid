const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/top", async (req, res) => {
  try {
    const response = await axios.get(
      "https://newsapi.org/v2/everything",
      {
        params: {
          q: "technology",
          language: "en",
          sortBy: "publishedAt",
          apiKey: process.env.NEWS_API_KEY
        }
      }
    );

    res.json({
      status: "ok",
      articles: response.data.articles
    });
  } catch (err) {
    console.error(err.response?.data || err.message);
    res.status(500).json({ error: "Failed to fetch news" });
  }
});

module.exports = router;
