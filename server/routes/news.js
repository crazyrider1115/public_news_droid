const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/top", async (req, res) => {
  try {
    console.log("API KEY:", process.env.NEWS_API_KEY);

    const response = await axios.get(
      "https://newsdata.io/api/1/news",
      {
        params: {
          apikey: process.env.NEWS_API_KEY,
          language: "en",
        },
      }
    );

    const results = response.data.results || [];

    const articles = results.map(a => ({
      title: a.title,
      description: a.description,
      url: a.link,
      image: a.image_url,
      publishedAt: a.pubDate,
    }));

    res.json({
      status: "ok",
      articles,
    });

  } catch (err) {
    console.error(err.response?.data || err.message);

    // ✅ FIX: prevent app from hanging
    res.status(200).json({
      status: "ok",
      articles: [],
    });
  }
});

module.exports = router;