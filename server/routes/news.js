const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/top", async (req, res) => {
  try {
    const response = await axios.get(
      "https://newsdata.io/api/1/news",
      {
        params: {
          apikey: process.env.NEWSDATA_API_KEY,
          language: "en",
        },
      }
    );

    const articles = response.data.results.map(a => ({
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
    res.status(500).json({ error: "Failed to fetch news" });
  }
});

module.exports = router;
