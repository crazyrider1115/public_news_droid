require('dotenv').config({ path: __dirname + '/.env' });

console.log("ENV CHECK:", process.env.NEWS_API_KEY);

const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const newsRoutes = require("./routes/news");
const authRoutes = require("./routes/auth");

const app = express();

app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect("mongodb://127.0.0.1:27017/public_news_droid")
.then(() => {
  console.log("MongoDB connected");
})
.catch((err) => {
  console.log("MongoDB connection error:", err);
});

// Routes
app.use("/news", newsRoutes);
app.use("/auth", authRoutes);

// Optional root route
app.get("/", (req, res) => {
  res.send("Server working 🚀");
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});