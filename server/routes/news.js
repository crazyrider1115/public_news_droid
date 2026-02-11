const express = require("express");
const axios = require("axios");

const router = express.Router();

const API_KEYS = process.env.NEWS_API_KEYS.split(",");

let currentKeyIndex = 0;

function getApiKey() {
  const key = API_KEYS[currentKeyIndex];
  currentKeyIndex = (currentKeyIndex + 1) % API_KEYS.length;
  return key;
}

router.get("/top", async (req, res) => {
  try {
    const { category, date } = req.query;

    const categoryMap = {
      technology: "technology OR AI OR software",
      politics: "politics OR government OR election",
      sports: "sports OR football OR cricket OR match",
      business: "business OR economy OR finance OR market",
    };

    const params = {
      language: "en",
      sortBy: "publishedAt",
      apiKey: getApiKey(),
      q: categoryMap[category] || "news",
    };

    if (date) {
      params.from = date;
      params.to = date;
    }

    const response = await axios.get(
      "https://newsapi.org/v2/everything",
      { params }
    );

    res.json({
      status: "ok",
      articles: response.data.articles,
    });
  } catch (err) {
    console.error(err.response?.data || err.message);
    res.status(500).json({ error: "Failed to fetch news" });
  }
});


module.exports = router;
