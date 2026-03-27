const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// 🔥 ROUTES
const authRoutes = require("./routes/auth.js");
app.use("/api/auth", authRoutes);

// 🔥 TEST ROUTE
app.get("/", (req, res) => {
  res.send("API is running...");
});

// 🔥 MONGODB CONNECT
mongoose.connect("mongodb://127.0.0.1:27017/newsdroid")
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// 🔥 IMPORTANT (ALLOW PHONES)
app.listen(5000, "0.0.0.0", () => {
  console.log("Server running on port 5000");
});

console.log("AUTH ROUTES LOADED");