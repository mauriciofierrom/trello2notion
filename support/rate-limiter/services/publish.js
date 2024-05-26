const { PubSub } = require('@google-cloud/pubsub');

module.exports = async (data) => {
  const pubSubClient = new PubSub();
  const topicName = "t2n-file-ready"
  const dataBuffer = Buffer.from(JSON.stringify(data));

  try {
    const messageId = await pubSubClient
          .topic(topicName)
          .publishMessage({data: dataBuffer});
    console.log(`Message ${messageId} published.`);
  } catch (error) {
    console.error(`Received error while publishing: ${error.message}`);
    process.exitCode = 1;
  }
}
