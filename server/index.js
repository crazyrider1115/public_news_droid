// 🔥 SETUP
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// 🔥 ROUTES
const authRoutes = require("./routes/auth.js");
const newsRoutes = require("./routes/news.js");

app.use("/api/auth", authRoutes);
app.use("/news", newsRoutes);
console.log("ROUTES LOADED");

// 🔥 TEST ROUTE
app.get("/", (req, res) => {
  res.send("API is running...");
});

// 🔥 MONGODB CONNECT & START SERVER
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/newsdroid";

mongoose.connect(MONGO_URI)
  .then(() => {
    console.log("MongoDB connected");
    // 🔥 IMPORTANT (ALLOW PHONES)
    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error("Database connection error:", err);
    process.exit(1);
  });
