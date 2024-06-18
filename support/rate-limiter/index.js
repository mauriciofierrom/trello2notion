const functions = require("@google-cloud/functions-framework");

const rateLimit = require("./middlewares/rate-limit");
const auth = require("./middlewares/auth");
const fileUpload = require("./middlewares/file-upload");
const notionToken = require("./middlewares/notion-token");
const runMiddlewares = require("./util/middleware-runner");

functions.http("rate-limiter", async (req, res) => {
  const middlewares = [rateLimit, auth, fileUpload, notionToken];

  try {
    await runMiddlewares(middlewares, req, res);
    res.status(200).send("We're done here");
  } catch (error) {
    res.status(error.status || 500).send(error.message);
  }
});
