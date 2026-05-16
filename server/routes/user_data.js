const express = require("express");
const router = express.Router();
const User = require("../models/user");

/* ---------- SAVE NEWS ---------- */
router.post("/save-news", async (req, res) => {
  try {
    const { username, article } = req.body;
    
    // Check if user exists
    const user = await User.findOne({ username });
    if (!user) return res.json({ success: false, message: "User not found" });

    // Check if already saved based on title or URL
    const alreadySaved = user.savedNews.some(item => item.url === article.url || item.title === article.title);
    
    if (alreadySaved) {
      return res.json({ success: false, message: "Article already saved" });
    }

    user.savedNews.push(article);
    await user.save();

    res.json({ success: true, message: "News saved successfully" });
  } catch (err) {
    console.error(err);
    res.json({ success: false, message: "Server error" });
  }
});

/* ---------- UNSAVE NEWS ---------- */
router.post("/unsave-news", async (req, res) => {
  try {
    const { username, articleUrl } = req.body;

    const user = await User.findOne({ username });
    if (!user) return res.json({ success: false, message: "User not found" });

    user.savedNews = user.savedNews.filter(item => item.url !== articleUrl);
    await user.save();

    res.json({ success: true, message: "News removed from saved" });
  } catch (err) {
    console.error(err);
    res.json({ success: false, message: "Server error" });
  }
});

/* ---------- GET SAVED NEWS ---------- */
router.post("/get-saved-news", async (req, res) => {
  try {
    const { username } = req.body;
    const user = await User.findOne({ username });
    if (!user) return res.json({ success: false, message: "User not found" });

    res.json({ success: true, savedNews: user.savedNews });
  } catch (err) {
    console.error(err);
    res.json({ success: false, message: "Server error" });
  }
});

module.exports = router;
