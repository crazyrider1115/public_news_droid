const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const User = require("../models/User");

/* ---------- SIGNUP ---------- */
router.post("/signup", async (req, res) => {

  try {
    console.log("Signup request received:", req.body);
    const { name, username, password } = req.body;

    const exists = await User.findOne({ username });

    if (exists) {
      return res.json({ message: "User already exists" });
    }

    // 🔐 hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      name,
      username,
      password: hashedPassword,
      approved: false
    });

    await newUser.save();

    console.log("NEW USER SIGNED UP:", username);

    res.json({ message: "Signup successful. Wait for admin approval" });

  } catch (err) {

    console.log(err);
    res.status(500).json({ message: "Server error" });

  }

});


/* ---------- LOGIN ---------- */
router.post("/login", async (req, res) => {

  try {

    const { username, password } = req.body;

    const user = await User.findOne({ username });

    if (!user) {
      return res.json({ success: false, message: "Invalid username or password" });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.json({ success: false, message: "Invalid username or password" });
    }

    if (!user.approved) {
      return res.json({ success: false, message: "Account not approved yet" });
    }

    console.log("USER LOGGED IN:", username);

    res.json({ success: true });

  } catch (err) {

    console.log(err);
    res.status(500).json({ message: "Server error" });

  }

});


/* ---------- GET PENDING USERS ---------- */
router.get("/pending", async (req, res) => {

  const users = await User.find({ approved: false });

  res.json(users);

});


/* ---------- APPROVE USER ---------- */
router.post("/approve", async (req, res) => {

  const { username } = req.body;

  await User.updateOne(
    { username },
    { approved: true }
  );

  console.log("USER APPROVED:", username);

  res.json({ success: true });

});


module.exports = router;