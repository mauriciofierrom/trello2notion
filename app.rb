# frozen_string_literal: true

require "base64"
require "functions_framework"
require "google/cloud/firestore"
require "google/cloud/storage"
require "json"
require "sendgrid-ruby"

require_relative "lib/trello2notion/trello/decorators"
require_relative "lib/trello2notion/trello/json_export"
require_relative "lib/trello2notion/trello/notion/client"
require_relative "lib/trello2notion/trello/notion/parent"

BUCKET_NAME = "t2n-trigger-bucket"
RESULT_BUCKET_NAME = "t2n-result-bucket"
SENDER_EMAIL = "trello2notion@mauriciofierro.dev"

# rubocop:disable Style/MixinUsage
include Trello2Notion::Trello
# rubocop:enable Style/MixinUsage

# rubocop:disable Metrics/BlockLength
FunctionsFramework.cloud_event "trello2notion" do |cloud_event|
  data = JSON.parse(Base64.decode64(cloud_event.data["message"]["data"]))
  pp data

  storage = Google::Cloud::Storage.new
  bucket  = storage.bucket BUCKET_NAME, skip_lookup: true
  file    = bucket.file data["file"]

  downloaded = file.download
  contents = downloaded.read
  parsed_board = JSONExport.parse(JSON.parse(contents))

  case data["method"]
  when "markdown"
    markdown = MarkdownDecorator.new(parsed_board).generate
    result_bucket = storage.bucket RESULT_BUCKET_NAME, skip_lookup: true
    result_bucket.create_file StringIO.new(markdown), "#{data["email"]}_#{Time.now.to_i}.md"
    # Send email
    # send_email(data["email"], generated_file.url)
  when "notion"
    notion_info = fetch_notion_info(data["email"])
    notion_client = Trello2Notion::Trello::Notion::Client.new(notion_info["accessToken"])

    base_page, subpages_builder = NotionDecorator.new(parsed_board).generate
    base_page.parent = Trello2Notion::Notion::PageParent.new(page_id: notion_info["workspaceId"])
    page_id = notion_client.create_page(base_page.to_json)
    # rubocop:disable Style/RescueStandardError
    subpages_builder.call(page_id:).each do |subpage|
      notion_client.create_page(subpage.to_json)
    rescue
      pp subpage
    end
    # rubocop:enable Style/RescueStandardError
  else
    # Will raise 500 automatically by the functions framework
    raise "No valid method"
  end
end
# rubocop:enable Metrics/BlockLength

# rubocop:disable Style/MixinUsage
def send_email(email, file_url)
  include Sendgrid

  from = SendGrid::Email.new(email: SENDER_EMAIL)
  to = SendGrid::Email.new(email:)
  subject = "Trello2Notion: Markdown file download link"
  content = SendGrid::Content.new(type: "text/plain", value: "Your Trello board converted to Markdown: #{file_url}")

  mail = SendGrid::Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV.fetch["SENDGRID_API_KEY"])
  sg.client.mail._("send").post(request_body: mail.to_json)
end
# rubocop:enable Style/MixinUsage

def fetch_notion_token(email)
  firestore = Google::Cloud::Firestore.new project_id: "trello2notion"

  # Get a collection reference
  cities_col = firestore.col "t2n-notion-token"

  # Create a query
  notion_info, * = cities_col.where(:email, :==, email).get
  notion_info
end
