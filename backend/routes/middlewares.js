const prisma = require("../prismaClient");

const jwt = require("jsonwebtoken");
const secretKey = process.env.SECRET_AUTH_KEY;

// Middleware for token verification
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) return res.status(401).json({ message: "Token required." });

  jwt.verify(token, secretKey, (err, user) => {
    if (err)
      return res.status(403).json({ message: "Invalid or expired token." });
    req.user = user;
    next();
  });
};

// only ADMIN will be able to access endpoints with this middleware
const adminRequired = async (req, res, next) => {
  try {
    // get the user with its id from the authenticateToken middleware
    const authUser = req.user;

    // fetch user from DB by its id
    const dbUser = await prisma.user.findUnique({
      where: { id: authUser.id },
    });

    // make sure the user exists
    if (!dbUser) return res.status(404).json({ message: "User not found." });

    if (dbUser.role !== "ADMIN") {
      return res.status(403).json({ message: "Admin access required." });
    }

    // Attach user to request and proceed
    req.user = dbUser;
    next();
  } catch (err) {
    return res.status(403).json({ message: "Invalid or expired token." });
  }
};

// only ADMIN or an USER WITH THE SAME ID from the endpoint call will be able
// to access endpoints with this middleware
const adminOrSelfRequired = async (req, res, next) => {
  try {
    // get the user with its id from the authenticateToken middleware
    const authUser = req.user;

    // fetch user from DB by its id
    const dbUser = await prisma.user.findUnique({
      where: { id: authUser.id },
    });

    // make sure the user exists
    if (!dbUser) return res.status(404).json({ message: "User not found." });

    // allow if admin or self
    const targetId = parseInt(req.params.id);
    if (dbUser.role === "ADMIN" || dbUser.id === targetId) {
      return next();
    }

    return res
      .status(403)
      .json({ message: "You do not have permission to perform this action." });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Server error." });
  }
};

module.exports = {
  authenticateToken,
  adminRequired,
  adminOrSelfRequired,
};
