const express = require("express");
const router = express.Router();

<<<<<<< HEAD
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
=======
let users = [];

// SIGNUP
router.post("/signup", (req, res) => {
  const { name, username, password } = req.body;

  const exists = users.find(u => u.username === username);

  if (exists) {
    return res.json({ message: "User already exists" });
  }

  const newUser = {
    name,
    username,
    password,
    approved: false
  };

  users.push(newUser);

  console.log("NEW USER SIGNED UP:");
  console.log(newUser);

  res.json({ message: "Signup successful. Wait for admin approval" });
});


// LOGIN
>>>>>>> feature-filters
router.post("/login", (req, res) => {
  const { username, password } = req.body;

  const user = users.find(
    u => u.username === username && u.password === password
  );

  if (!user) {
<<<<<<< HEAD
    return res.status(401).json({ message: "Invalid credentials" });
  }

  if (!user.approved) {
    return res.status(403).json({ message: "User not approved yet" });
  }

  res.json({ message: "Login successful" });
});

router.get("/pending", (req, res) => {
  const pendingUsers = users.filter(u => !u.approved);
=======
    return res.json({ success: false, message: "Invalid username or password" });
  }

  if (!user.approved) {
    return res.json({ success: false, message: "Account not approved yet" });
  }

  console.log("USER LOGGED IN:");
  console.log(username);

  res.json({ success: true });
});


// GET PENDING USERS
router.get("/pending", (req, res) => {
  const pendingUsers = users.filter(u => !u.approved);

>>>>>>> feature-filters
  res.json(pendingUsers);
});


<<<<<<< HEAD
// 🔹 APPROVE USER
=======
// APPROVE USER
>>>>>>> feature-filters
router.post("/approve", (req, res) => {
  const { username } = req.body;

  const user = users.find(u => u.username === username);

  if (!user) {
<<<<<<< HEAD
    return res.status(404).json({ message: "User not found" });
=======
    return res.json({ success: false });
>>>>>>> feature-filters
  }

  user.approved = true;

<<<<<<< HEAD
  console.log("Approved users:", users);


  res.json({ message: "User approved successfully" });
=======
  console.log("USER APPROVED:");
  console.log(username);

  res.json({ success: true });
>>>>>>> feature-filters
});

module.exports = router;