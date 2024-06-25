const Firestore = require('@google-cloud/firestore');

module.exports = async (req, res) => {
  // We're getting the Notion code to exchange for the token
  if(req.method === "POST" && req.contentType === "application/json") {
    const { notionCode, email } = JSON.parse(req.body);
    const clientId = process.env.OAUTH_CLIENT_ID;
    const clientSecret = process.env.OAUTH_CLIENT_SECRET;
    const redirectUri = process.env.OAUTH_REDIRECT_URI;
    const encoded = Buffer.from(`${clientId}:${clientSecret}`).toString("base64");

    if(notionCode) {
      const response = await fetch("https://api.notion.com/v1/oauth/token", {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
          Authorization: `Basic ${encoded}`,
        },

        // Not including the redirect_url as it shouldn't be included
        body: JSON.stringify({
          grant_type: "authorization_code",
          code: notionCode,
        })
      });

      if(response.ok) {
        const db = new Firestore({
          projectId: 'trello2notion',
          keyFilename: '/path/to/keyfile.json', // WTF is the keyfile
        });

        const responseData = await response.json();

        // Save to Firestore
        const data = {
          email: email,
          workspaceName: responseData.workspace_name,
          workspaceId: responseData.workspace_id,
          accessToken: responseData.access_token
        };

        try {
          await db.collection('t2n-notion-token').doc(email).set(data);
        } catch (e) {
          res.status(500).send(`Failed storing notion token: ${e}`);
        }

        // Return integration information for local client storage
        res.send({workspaceName: data.workspaceName});
      } else {
        const { error } = await response.json();
        res.status(response.code).send(`Notion error: ${error}`);
      }
    }
  }
}
