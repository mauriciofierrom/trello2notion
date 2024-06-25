const Firestore = require('@google-cloud/firestore');

module.exports = async (req, res) => {
  // We're getting the Notion code to exchange for the token
  if(req.method === "POST" && req.get("Content-Type") === "application/json") {
    const { notionCode, email } = req.body;
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
          redirect_uri: redirectUri
        })
      });

      if(response.ok) {
        const db = new Firestore({
          projectId: 'trello2notion'
        });

        const responseData = await response.json();

        // Save to Firestore
        const data = {
          workspaceName: responseData.workspace_name,
          workspaceId: responseData.workspace_id,
          accessToken: responseData.access_token
        };

        try {
          await db.collection('t2n-notion-token').doc(email).set(data);

          // Return integration information for local client storage
          res.send({workspaceName: data.workspaceName});
        } catch (e) {
          res.status(500).send(`Failed storing notion token: ${e}`);
        }
      } else {
        const { error } = await response.json();
        res.status(response.code).send(`Notion error: ${error}`);
      }
    }
  }
}
