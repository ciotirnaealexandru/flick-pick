const express = require("express");
const router = express.Router();
const prisma = require("../prismaClient");

// for auth using an array
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secretKey = process.env.SECRET_AUTH_KEY;

// get all users
router.get("/users", async (req, res) => {
  const users = await prisma.user.findMany();
  res.json(users);
});

// get user by id
router.get("/users/:id", async (req, res) => {
  const user = await prisma.user.findUnique({
    where: {
      id: parseInt(req.params.id),
    },
  });

  if (!user) {
    return res.status(401).send("User does not exist");
  }

  res.json(user);
});

// SIGN UP
router.post("/signup", async (req, res) => {
  const { firstName, lastName, email, password } = req.body;

  try {
    const existingUser = await prisma.user.findUnique({
      where: {
        email: req.body.email,
      },
    });

    if (existingUser) {
      return res.status(409).json({ message: "Email already in use." });
    }

    const user = await prisma.user.create({
      data: {
        firstName,
        lastName,
        email,
        password: await bcrypt.hash(password, 12),
      },
    });
    res.status(200).send({ user });
  } catch (error) {
    console.error("Error registering user:", error);
    res.status(500).json({ message: "Server error" });
  }
});

// LOGIN
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await prisma.user.findUnique({
      where: {
        email: req.body.email,
      },
    });

    // if the user does not exist or the password is wrong
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).send("Invalid credentials");
    }

    // generate token
    const token = jwt.sign(
      {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      },
      secretKey,
      {
        expiresIn: "2h",
      }
    );

    res.status(200).send({ token });
  } catch (error) {
    console.error("Error registering user:", error);
    res.status(500).json({ message: "Server error" });
  }
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

router.get("/info", authenticateToken, (req, res) => {
  res.status(200).send({
    id: req.user.id,
    firstName: req.user.firstName,
    lastName: req.user.lastName,
    email: req.user.email,
  });
});

router.get("/user/shows", authenticateToken, (req, res) => {
  // TODO
});

router.get("/user/shows/watched", authenticateToken, (req, res) => {
  // TODO
});

router.get("/user/shows/will_watch", authenticateToken, (req, res) => {
  // TODO
});

router.post("/user/show", authenticateToken, (req, res) => {
  const { apiId, name, summary, imageUrl } = req.body;
  // TODO
});

module.exports = router;
