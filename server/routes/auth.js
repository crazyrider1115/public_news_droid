const express = require("express");
const router = express.Router();

// Simple in-memory user storage
let users = [
  { username: "admin", password: "admin", approved: true }
];

// 🔹 SIGNUP
router.post("/signup", (req, res) => {
  const { username, password } = req.body;

  const existingUser = users.find(u => u.username === username);
  if (existingUser) {
    return res.status(400).json({ message: "User already exists" });
  }

  users.push({
    username,
    password,
    approved: false
  });

  console.log("Current users:", users);

  res.json({ message: "Signup successful. Waiting for admin approval." });
});

// 🔹 LOGIN
router.post("/login", (req, res) => {
  const { username, password } = req.body;

  const user = users.find(
    u => u.username === username && u.password === password
  );

  if (!user) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  if (!user.approved) {
    return res.status(403).json({ message: "User not approved yet" });
  }

  res.json({ message: "Login successful" });
});

router.get("/pending", (req, res) => {
  const pendingUsers = users.filter(u => !u.approved);
  res.json(pendingUsers);
});


// 🔹 APPROVE USER
router.post("/approve", (req, res) => {
  const { username } = req.body;

  const user = users.find(u => u.username === username);

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  user.approved = true;

  console.log("Approved users:", users);


  res.json({ message: "User approved successfully" });
});

module.exports = router;