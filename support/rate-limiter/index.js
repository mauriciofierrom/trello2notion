const functions = require("@google-cloud/functions-framework");
const rateLimit = require("./middlewares/rate-limit");
const cors = require("./middlewares/cors");
const auth = require("./middlewares/auth");
const fileUpload = require("./middlewares/file-upload");
const notionToken = require("./middlewares/notion-token");
const runMiddlewares = require("./util/middleware-runner");

functions.http("rate-limiter", async (req, res) => {
  const middlewares = [rateLimit, cors, auth, fileUpload, notionToken];

  res.set('Access-Control-Allow-Origin', '*');

  try {
    await runMiddlewares(middlewares, req, res);

    // Fallback response
    res.status(200).send("We're done here");
  } catch (error) {
    res.status(error.status || 500).send(error.message);
  }
});
