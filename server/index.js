// 🔥 SETUP
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const admin = require("firebase-admin");

const app = express();

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// 🔥 FIREBASE ADMIN
try {
  const serviceAccount = require("./firebase-admin.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  console.log("Firebase Admin Loaded!");
} catch (e) {
  console.log("Firebase not configured:", e.message);
}

// 🔥 ROUTES
const authRoutes = require("./routes/auth.js");
const newsRoutes = require("./routes/news.js");
const userDataRoutes = require("./routes/user_data.js");

app.use("/api/auth", authRoutes);
app.use("/api/user", userDataRoutes);
app.use("/news", newsRoutes);
console.log("ROUTES LOADED");

// 🔥 TEST ROUTE
app.get("/", (req, res) => {
  res.send("API is running...");
});

// 🔥 NOTIFICATIONS ENDPOINT
app.post("/api/admin/notify-news", async (req, res) => {
  const { title, body } = req.body;
  try {
    await admin.messaging().send({
      topic: "all_news",
      notification: {
        title: title || "New News Update!",
        body: body || "Check out the latest news now."
      }
    });
    res.json({ success: true, message: "Notification sent!" });
  } catch (error) {
    res.json({ success: false, error: error.message });
  }
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
