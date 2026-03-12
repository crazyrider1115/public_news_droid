const express = require("express");
const router = express.Router();

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
router.post("/login", (req, res) => {
  const { username, password } = req.body;

  const user = users.find(
    u => u.username === username && u.password === password
  );

  if (!user) {
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

  res.json(pendingUsers);
});


// APPROVE USER
router.post("/approve", (req, res) => {
  const { username } = req.body;

  const user = users.find(u => u.username === username);

  if (!user) {
    return res.json({ success: false });
  }

  user.approved = true;

  console.log("USER APPROVED:");
  console.log(username);

  res.json({ success: true });
});

module.exports = router;