const axios = require("axios");
const node_jwt = require("jsonwebtoken");
const jwksClient = require("jwks-rsa");

module.exports = async (req, res) => {
  const appUrl = process.env.APP_URL;
  const requestHeader = req.headers;
  if (requestHeader.authorization == undefined) {
    res.send("Invalid header");
    return;
  }
  const authorizationHeader = requestHeader.authorization.split(" ");
  const access_token = authorizationHeader[1];
  const decoded_access_token = node_jwt.decode(access_token, {
    complete: true,
  });
  const jwks_uri = await getJwksUri(appUrl);
  const client = jwksClient({
    strictSsl: true,
    jwksUri: jwks_uri,
  });
  const signing_key = await client.getSigningKey(
    decoded_access_token.header.kid,
  );

  try {
    const verify = node_jwt.verify(access_token, signing_key.publicKey, {
      algorithms: ["RS256"],
    });
    console.log(verify);
  } catch (error) {
    res.send(error);
  }
};

const getJwksUri = async (appUrl) => {
  const config_endpoint = appUrl + "/.well-known/openid-configuration";
  const data = await axios.get(config_endpoint);
  return data.data.jwks_uri;
};
