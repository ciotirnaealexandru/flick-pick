const express = require("express");
const app = express();

// enable cors
const cors = require("cors");
app.use(cors());

// for environment variables
require("dotenv").config();

// for importing json modules
const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json());

// connect to the databse
const prisma = require("./prismaClient");
async function main() {
  await prisma.$connect();
}
main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());

// redirect to routes/index.js
const route = require("./routes");
app.use("/", route);

// get the port from the environment file
const PORT = process.env.PORT || 3001;

app.listen(PORT, (error) => {
  if (!error) console.log("Server running at http://localhost:" + PORT + "/");
  else console.log("Error occurred, server can't start", error);
});
