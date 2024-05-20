const functions = require("@google-cloud/functions-framework");

const rateLimit = require("./middlewares/rate-limit");
// const auth = require("./middlewares/auth");
const fileUpload = require("./middlewares/file-upload");
const runMiddlewares = require("./util/middleware-runner");

functions.http("rate-limiter", async (req, res) => {
  // TODO: Enable the auth middleware when we actually write the frontend form
  // const middlewares = [rateLimit, auth, fileUpload];
  const middlewares = [rateLimit, fileUpload];

  try {
    await runMiddlewares(middlewares, req, res);
    res.status(200).send("We're done here");
  } catch (error) {
    res.status(error.status || 500).send(error.message);
  }
});
