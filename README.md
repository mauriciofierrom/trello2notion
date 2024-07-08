**NOTE:** This is still a work in progress

# Trello2notion

Web application to turn Trello JSON exports into Notion pages.

## Contents

- A library to convert markdown to Notion objects to be used with the Notion API
- Conversion from a Trello JSON export to a Markdown document
- Conversion from a Trello JSON export to a Notion page (and subpages)
- Cloud function to perform the conversion
- Cloud function as entry-point to perform rate-limitting, validation and file
  upload to GCS (among other things)
- Cloud function to respond to a budget alert to disable billing when reaching a
  cap
- Terraform configuration
- Auth via Authgear
- A basic frontend to test the features https://github.com/mauriciofierrom/trello2notion-web
