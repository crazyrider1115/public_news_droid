const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const User = require("../models/user");

/* ---------- SIGNUP ---------- */
router.post("/signup", async (req, res) => {
  console.log("SIGNUP HIT", req.body);

  try {
    const { name, username, password } = req.body;

    const exists = await User.findOne({ username });
    if (exists) {
      return res.status(400).json({ message: "User already exists" }); // ✅ FIX
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      name,
      username,
      password: hashedPassword,
      approved: false,
    });

    await newUser.save();

    console.log("NEW USER SIGNED UP:", username);

    res.json({ message: "Signup successful" });

  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ---------- LOGIN ---------- */
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  const user = await User.findOne({ username });

  if (!user) {
    return res.json({ success: false, message: "Invalid username or password" });
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return res.json({ success: false, message: "Invalid username or password" });
  }

  if (!user.approved) {
    return res.json({ success: false, message: "Account not approved yet" });
  }

  console.log("USER LOGGED IN:", username);

  res.json({ success: true });
});

/* ---------- PENDING USERS ---------- */
router.get("/pending", async (req, res) => {
  const users = await User.find({ approved: false });
  res.json(users);
});

/* ---------- RESET PASSWORD (SIMULATED EMAIL) ---------- */
router.post("/reset-password", async (req, res) => {
  const { username, newPassword } = req.body;
  const user = await User.findOne({ username });

  if (!user) {
    return res.json({ success: false, message: "User not found" });
  }

  const hashedPassword = await bcrypt.hash(newPassword, 10);
  await User.updateOne({ username }, { password: hashedPassword });

  res.json({ success: true, message: "Password updated successfully" });
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

/* ---------- REJECT USER ---------- */
router.post("/reject", async (req, res) => {
  const { username } = req.body;

  await User.deleteOne({ username });

  console.log("USER REJECTED:", username);

  res.json({ success: true });
});

/* ---------- UPDATE PROFILE PICTURE ---------- */
router.post("/update-profile-picture", async (req, res) => {
  try {
    const { username, profilePicture } = req.body;
    await User.updateOne({ username }, { profilePicture });
    res.json({ success: true, message: "Profile picture updated" });
  } catch (err) {
    res.json({ success: false });
  }
});

/* ---------- DELETE PROFILE PICTURE ---------- */
router.post("/delete-profile-picture", async (req, res) => {
  try {
    const { username } = req.body;
    await User.updateOne({ username }, { profilePicture: "" });
    res.json({ success: true, message: "Profile picture deleted" });
  } catch (err) {
    res.json({ success: false });
  }
});

/* ---------- UPDATE PROFILE DETAILS ---------- */
router.post("/update-profile", async (req, res) => {
  try {
    const { currentUsername, newUsername, newName } = req.body;
    
    if (currentUsername !== newUsername) {
      const exists = await User.findOne({ username: newUsername });
      if (exists) {
        return res.json({ success: false, message: "Username already taken" });
      }
    }
    
    await User.updateOne({ username: currentUsername }, { username: newUsername, name: newName });
    res.json({ success: true, message: "Profile updated successfully", newUsername });
  } catch (err) {
    res.json({ success: false, message: "Error updating profile" });
  }
});

/* ---------- DELETE ACCOUNT ---------- */
router.post("/delete-account", async (req, res) => {
  try {
    const { username } = req.body;
    await User.deleteOne({ username });
    res.json({ success: true, message: "Account deleted" });
  } catch (err) {
    res.json({ success: false });
  }
});

/* ---------- GET USER PROFILE ---------- */
router.post("/profile", async (req, res) => {
  console.log("PROFILE FETCH REQUEST:", req.body);
  try {
    const { username } = req.body;
    if (!username) {
      console.log("PROFILE ERROR: No username provided");
      return res.status(400).json({ success: false, message: "Username required" });
    }

    const user = await User.findOne({ username });
    if (!user) {
      console.log("PROFILE ERROR: User not found:", username);
      return res.status(404).json({ success: false, message: "User not found" });
    }

    console.log("PROFILE FOUND FOR:", username);
    res.json({
      success: true,
      user: {
        username: user.username,
        name: user.name,
        profilePicture: user.profilePicture || ""
      }
    });
  } catch (err) {
    console.error("PROFILE FETCH ERROR:", err.message);
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;