const express = require("express");
const router = express.Router();

// for db
const prisma = require("../../prismaClient");
const { Role } = require("@prisma/client");

// for auth using an array
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secretKey = process.env.JWT_AUTH_KEY;

// middlewares
const {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
} = require("../middlewares");

const expirationTime = "2h";

// SIGN UP user based on firstName, lastName, email, password
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
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

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
      return res.status(404).json({ message: "Invalid credentials." });
    }

    // generate token
    const token = jwt.sign(
      {
        id: user.id,
      },
      secretKey,
      {
        expiresIn: expirationTime,
      }
    );

    res.status(200).send({ token });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// create a temporary GUEST account
router.get("/guest", async (req, res) => {
  try {
    const guestUser = await prisma.user.create({
      data: {
        firstName: "Guest First",
        lastName: "Guest Last",
        email: `guest_${Math.floor(Date.now() / 1000)}@gmail.com`,
        phone: null,
        password: await bcrypt.hash("guest", 12),
        role: Role.GUEST,
      },
    });

    // generate token
    const token = jwt.sign(
      {
        id: guestUser.id,
      },
      secretKey,
      {
        expiresIn: expirationTime,
      }
    );

    res.status(200).send({ token });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// GET INFO about the current user via the JWT token
router.get("/me", authenticateToken, async (req, res) => {
  try {
    // search the user by its id in the JWT
    const user = await prisma.user.findUnique({
      where: {
        id: parseInt(req.user.id),
      },
    });

    if (!user) {
      return res.status(404).json({ message: "User does not exist." });
    }

    return res.status(200).send({
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      role: user.role,
    });
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// READ all users
router.get("/all", authenticateToken, adminRequired, async (req, res) => {
  try {
    const users = await prisma.user.findMany();
    res.json(users);
  } catch (error) {
    console.error("Something went wrong: ", error);
    res.status(500).json({ message: "Server error." });
  }
});

// READ user by id
router.get(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const user = await prisma.user.findUnique({
        where: {
          id: parseInt(req.params.user_id),
        },
      });

      if (!user) {
        return res.status(404).json({ message: "User does not exist." });
      }

      res.json(user);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// UPDATE user by id
router.patch(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      const { newFirstName, newLastName, newEmail, newPhone } = req.body;

      // search the user by its id in the JWT
      const user = await prisma.user.findUnique({
        where: {
          id: parseInt(req.user.id),
        },
      });

      // check it the user exists
      if (!user) {
        return res.status(404).json({ message: "User does not exist." });
      }

      // check it the user is a guest
      if (user.role == Role.GUEST) {
        return res
          .status(500)
          .json({ message: "Can't update profile as a guest." });
      }

      // search for users with the new email to prevent duplicates
      const duplicateEmail = await prisma.user.findUnique({
        where: {
          email: newEmail,
        },
      });

      // check if it's not the user that has that email and it already exists
      if (duplicateEmail && duplicateEmail.id != req.params.user_id) {
        return res.status(401).json({ message: "Email already in use." });
      }

      // update the info
      const updatedUser = await prisma.user.update({
        where: {
          id: parseInt(req.params.user_id),
        },
        data: {
          firstName: newFirstName,
          lastName: newLastName,
          email: newEmail,
          phone: newPhone,
        },
      });

      // return the new user
      res.json(updatedUser);
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

// DELETE user by id
router.delete(
  "/:user_id",
  authenticateToken,
  adminOrSelfRequired,
  async (req, res) => {
    try {
      // search the user by its id in the JWT
      const user = await prisma.user.findUnique({
        where: {
          id: parseInt(req.user.id),
        },
      });

      // check it the user exists
      if (!user) {
        return res.status(404).json({ message: "User does not exist." });
      }

      // delete the shows of that user
      await prisma.userShow.deleteMany({
        where: {
          userId: parseInt(req.params.user_id),
        },
      });

      // delete the decks of that user
      await prisma.deck.deleteMany({
        where: {
          userId: parseInt(req.params.user_id),
        },
      });

      // delete the user
      await prisma.user.delete({
        where: {
          id: parseInt(req.params.user_id),
        },
      });

      res.status(200).json({ message: "User succesfully deleted." });
    } catch (error) {
      console.error("Something went wrong: ", error);
      res.status(500).json({ message: "Server error." });
    }
  }
);

module.exports = router;
