const express = require("express");
const app = express();

require("@prisma/client");
require("dotenv").config();

const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// redirect to routes/index.js
const route = require("./routes");
app.use("/", route);

// get the port from the environment file
const PORT = process.env.PORT || 3001;

app.listen(PORT, (error) => {
  if (!error) console.log("Server running at http://localhost:" + PORT + "/");
  else console.log("Error occurred, server can't start", error);
});
