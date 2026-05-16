const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: String,
  username: {
    type: String,
    unique: true
  },
  password: String,
  approved: {
    type: Boolean,
    default: false
  },
  profilePicture: {
    type: String,
    default: ""
  },
  savedNews: {
    type: Array,
    default: []
  }
});

module.exports = mongoose.model("User", userSchema);