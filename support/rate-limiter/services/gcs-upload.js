const { Storage } = require("@google-cloud/storage");
const { v4: uuidv4 } = require("uuid");

module.exports = async (filepath, method = "markdown") => {
  const storage = new Storage();
  const bucketName = "t2n-trigger-bucket";
  const fileName = uuidv4();
  const options = {
    destination: `${fileName}-${method}.json`,
  };

  await storage.bucket(bucketName).upload(filepath, options);
  console.log(`${filepath} uploaded successfully!`);

  return `${filepath} uploaded successfully!`;
};
