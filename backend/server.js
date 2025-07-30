const express = require("express");

const app = express();
app.use(express.json());

// for port configuration
require("dotenv").config();
const PORT = process.env.PORT;

app.listen(PORT, (error) => {
  if (!error) console.log("Server running at http://localhost:" + PORT + "/");
  else console.log("Error occurred, server can't start", error);
});

// for auth
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secretKey = process.env.SECRET_AUTH_KEY;
let users = [];

// HELLO WORLD
app.get("/", async (req, res) => {
  res.status(200);
  res.send("Hello world!");
});

// REGISTER
app.post("/register", async (req, res) => {
  const { username, password } = req.body;

  // hash password
  const hashedPassword = await bcrypt.hash(password, 8);
  // store user
  users.push({ username, password: hashedPassword });

  res.status(201);
  res.send("User created");
});

// LOGIN
app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  // try to find user
  const user = users.find((u) => u.username === username);

  // if the user does not exist or the password is wrong
  if (!user || !(await bcrypt.compare(password, user.password))) {
    return res.status(401).send("Invalid credentials");
  }

  // generate token
  const token = jwt.sign({ userId: user.username }, secretKey, {
    expiresIn: "1h",
  });

  res.status(200).send({ token });
});

// Middleware for token verification
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) return res.status(401).send("Token required");

  jwt.verify(token, secretKey, (err, user) => {
    if (err) return res.status(403).send("Invalid or expired token");
    req.user = user;
    next();
  });
};

app.get("/dashboard", authenticateToken, (req, res) => {
  res.status(200).send("Welcome to the dashboard, " + req.user.userId);
});
