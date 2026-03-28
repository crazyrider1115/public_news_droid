const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/top", async (req, res) => {
  try {
    const { category } = req.query;

    const response = await axios.get(
      "https://newsdata.io/api/1/news",
      {
        params: {
          apikey: process.env.NEWS_API_KEY,
          language: "en",
          category: category === "all" ? undefined : (category || "top"), // ✅ FILTER FIX
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
      source: a.source_id || a.source_name || "Unknown",
    }));

    res.json({
      status: "ok",
      articles,
    });

  } catch (err) {
    console.error(err.response?.data || err.message);

    res.status(200).json({
      status: "ok",
      articles: [],
    });
  }
});

module.exports = router;