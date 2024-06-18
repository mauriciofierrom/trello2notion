const fs = require("fs");
const Busboy = require("busboy");
const path = require("path");
const os = require("os");
const uploadToGcs = require("../services/gcs-upload");
const publish = require("../services/publish");
const Firestore = require('@google-cloud/firestore');

module.exports = (req, res) => {
  // We're getting the form data with the file to convert
  if (req.method === "POST" && req.contentType === "multipart/form-data") {
    const bb = Busboy({
      headers: req.headers,
      limits: { fileSize: 10 * 1024 * 1024 },
    });
    const tmpdir = os.tmpdir();
    const fileWrites = [];
    const uploads = {};
    const fields = {};

    bb.on("file", (fieldname, file, { filename }) => {
      console.log(`Processed file ${filename}`);
      const filepath = path.join(tmpdir, filename);
      uploads[fieldname] = filepath;

      const writeStream = fs.createWriteStream(filepath);
      file.pipe(writeStream);

      const promise = new Promise((resolve, reject) => {
        file.on("end", () => {
          writeStream.end();
        });
        writeStream.on("close", resolve);
        writeStream.on("error", reject);
      });

      fileWrites.push(promise);
    });

    bb.on("field", (name, val) => {
      fields[name] = val;
    });

    bb.on("finish", async () => {
      await Promise.all(fileWrites);

      for (const file in uploads) {
        if (validateFileType(uploads[file])) {
          const uploadedFile = await uploadToGcs(uploads[file]);
          await publish({
            method: fields.method,
            email: fields.email,
            file: uploadedFile.name
          });
        } else {
          res.status(400).send("Not a valid JSON file");
        }

        fs.unlinkSync(uploads[file]);
      }
    });

    bb.end(req.rawBody);
  } else {
    res.status(400).send("Not a POST request");
  }
};

const validateFileType = (filepath) => {
  try {
    const content = fs.readFileSync(filepath);
    JSON.parse(content);
    return true;
  } catch {
    return false;
  }
};
