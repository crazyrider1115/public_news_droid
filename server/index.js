require('dotenv').config();

const express = require("express");
const cors = require("cors");

/* -------------------- ADDED --------------------
   Import mongoose so Node.js can talk to MongoDB
-------------------------------------------------*/
const mongoose = require("mongoose");

const newsRoutes = require("./routes/news");
const authRoutes = require("./routes/auth");

const app = express();

app.use(cors());
app.use(express.json());

/* -------------------- ADDED --------------------
   Connect to MongoDB database.

   mongodb://127.0.0.1:27017  → MongoDB running locally
   public_news_droid          → database name

   If the DB doesn't exist, MongoDB automatically creates it.
-------------------------------------------------*/
mongoose.connect("mongodb://127.0.0.1:27017/public_news_droid")
.then(() => {
  console.log("MongoDB connected");   // confirms DB connection
})
.catch((err) => {
  console.log("MongoDB connection error:", err);
});

app.use("/news", newsRoutes);
app.use("/auth", authRoutes);

app.listen(5000, "0.0.0.0", () => {
  console.log("Server running on port 5000");
});