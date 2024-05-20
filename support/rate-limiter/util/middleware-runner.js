const runMiddlewares = async (middlewares, req, res) => {
  for (const middleware of middlewares) {
    await middleware(req, res);
  }
};

module.exports = runMiddlewares;
