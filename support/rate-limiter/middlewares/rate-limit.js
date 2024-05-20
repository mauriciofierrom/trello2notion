const { Ratelimit } = require("@upstash/ratelimit");
const { Redis } = require("@upstash/redis");

module.exports = async (_req, res) => {
  const ratelimit = new Ratelimit({
    redis: Redis.fromEnv(),
    limiter: Ratelimit.slidingWindow(10, "10 s"),
  });

  const identifier = "api";
  const { success } = await ratelimit.limit(identifier);

  if (!success) {
    res.status(429).send("Too many requests");
  }
};
