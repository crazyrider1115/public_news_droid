const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/top", async (req, res) => {
  try {
    const { category, date } = req.query;

    let articles = [];

    if (category === "all" || !category) {
      // Fetch a mix of categories for "All"
      const categories = ["top", "technology", "sports", "business", "science"];
      const promises = categories.map(cat => 
        axios.get("https://newsdata.io/api/1/news", {
          params: {
            apikey: process.env.NEWS_API_KEY,
            language: "en",
            category: cat,
            size: 5, // Get 5 from each
          },
        })
      );

      const results = await Promise.allSettled(promises);
      results.forEach(res => {
        if (res.status === "fulfilled" && res.value.data.results) {
          articles = [...articles, ...res.value.data.results];
        }
      });
      
      // Shuffle the combined list
      articles = articles.sort(() => Math.random() - 0.5);
    } else {
      // Single category fetch
      const response = await axios.get(
        "https://newsdata.io/api/1/news",
        {
          params: {
            apikey: process.env.NEWS_API_KEY,
            language: "en",
            category: category,
            size: 10,
          },
        }
      );
      articles = response.data.results || [];
    }

    let formattedArticles = articles.map(a => ({
      title: a.title,
      description: a.description,
      url: a.link,
      image: a.image_url,
      publishedAt: a.pubDate,
      source: a.source_id || a.source_name || "Unknown",
    }));

    if (date) {
      formattedArticles = formattedArticles.filter(a => {
        if (!a.publishedAt) return false;
        return a.publishedAt.startsWith(date);
      });
    }

    res.json({
      status: "ok",
      articles: formattedArticles,
    });

  } catch (err) {
    console.error("NEWS FETCH ERROR:", err.response?.data || err.message);

    res.status(200).json({
      status: "ok",
      articles: [],
    });
  }
});

module.exports = router;