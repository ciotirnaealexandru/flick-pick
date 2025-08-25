const express = require("express");
const router = express.Router();
const prisma = require("../../prismaClient");

// for auth using an array
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const e = require("express");
const secretKey = process.env.SECRET_AUTH_KEY;

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

// any
// SIGN UP user based on firstName, lastName, email, password
router.post("/signup", async (req, res) => {
  const { firstName, lastName, email, password, phone } = req.body;

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
        phone,
      },
    });
    res.status(200).send({ user });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// any
// LOGIN based on email and password and return a JWT token
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await prisma.user.findUnique({
      where: {
        email: email,
      },
    });

    // if the user does not exist or the password is wrong
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(404).send("Invalid credentials.");
    }

    // generate token
    const token = jwt.sign(
      {
        id: user.id,
      },
      secretKey,
      {
        expiresIn: "2h",
      }
    );

    res.status(200).send({ token });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// admin
// READ all users
router.get("/all", async (req, res) => {
  try {
    const users = await prisma.user.findMany();
    res.json(users);
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// admin
// READ user by id
router.get("/id/:id", async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: {
        id: parseInt(req.params.id),
      },
    });

    if (!user) {
      return res.status(404).send("User does not exist");
    }

    res.json(user);
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// admin, user
// UPDATE user by id
router.patch("/id/:id", authenticateToken, async (req, res) => {
  try {
    const { firstName, lastName, email, phone } = req.body;

    // search the user by its id in the JWT
    const user = await prisma.user.findUnique({
      where: {
        id: parseInt(req.user.id),
      },
    });

    // check it the authenticated user exists
    if (!user) {
      return res.status(404).send("User does not exist");
    }

    // make sure that the endpoint matches the authenticated user id
    if (req.params.id != user.id) {
      return res
        .status(403)
        .send("You do not have permission to change this user info.");
    }

    // search for users with the new password to prevent duplicates
    const duplicateEmail = await prisma.user.findUnique({
      where: {
        email: email,
      },
    });

    // if it's not the user that has that email and it already exists,
    // throw an error
    if (user.email != email && duplicateEmail) {
      return res.status(401).json({ message: "Email already in use." });
    }

    // if the user does exist, update the info
    const updatedUser = await prisma.user.update({
      where: {
        id: parseInt(req.params.id),
      },
      data: {
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      },
    });

    // return the new user
    res.json(updatedUser);
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// admin, user
// DELETE user by id
router.delete("/id/:id", authenticateToken, async (req, res) => {
  try {
    // search the user by its id in the JWT
    const user = await prisma.user.findUnique({
      where: {
        id: parseInt(req.user.id),
      },
    });

    // check it the authenticated user exists
    if (!user) {
      return res.status(404).send("User does not exist");
    }

    // make sure that the endpoint matches the authenticated user id
    if (req.params.id != user.id) {
      return res
        .status(403)
        .send("You do not have permission to delete this user.");
    }

    // if the user does exist, update the info
    await prisma.user.delete({
      where: {
        id: parseInt(req.params.id),
      },
    });

    // return the new user
    res.status(200).json({ message: "User succesfully deleted." });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// user
// GET info about the current user via the JWT token
router.get("/me", authenticateToken, async (req, res) => {
  try {
    // search the user by its id in the JWT
    const user = await prisma.user.findUnique({
      where: {
        id: parseInt(req.user.id),
      },
    });

    if (!user) {
      return res.status(404).send("User does not exist");
    }

    res.status(200).send({
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
    });

    return res.status(200).send({ user });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

module.exports = router;
