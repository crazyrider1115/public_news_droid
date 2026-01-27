require("dotenv").config();

const express = require("express");
const cors = require("cors");
const newsRoutes = require("./routes/news");

const app = express();

app.use(cors());
app.use(express.json());

// 🔴 THIS MUST RECEIVE A ROUTER FUNCTION
app.use("/news", newsRoutes);

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
