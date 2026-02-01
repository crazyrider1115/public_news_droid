const express = require("express");
const axios = require("axios");

const router = express.Router();

const API_KEYS = [
  "3dd04a9177c2474d86eccaed2f066444",
  "GZ39D9nx1dEn9voB7ME81ylTkOPdC_GFLX_1Caigi9vQ44Wr"
];

let currentKeyIndex = 0;

function getApiKey() {
  const key = API_KEYS[currentKeyIndex];
  currentKeyIndex = (currentKeyIndex + 1) % API_KEYS.length;
  return key;
}

router.get("/top", async (req, res) => {
  try {
    const response = await axios.get(
      "https://newsapi.org/v2/everything",
      {
        params: {
          q: "technology",
          language: "en",
          sortBy: "publishedAt",
          apiKey: getApiKey()
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
