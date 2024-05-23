# frozen_string_literal: true

require "functions_framework"
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

FunctionsFramework.cloud_event "trello2notion" do |cloud_event|
  storage = Google::Cloud::Storage.new
  bucket  = storage.bucket BUCKET_NAME, skip_lookup: true
  file    = bucket.file cloud_event["name"]

  downloaded = file.download
  contents = downloaded.read
  parsed_board = JSONExport.parse(JSON.parse(contents))

  case file.metadata["method"]
  when :markdown
    markdown = MarkdownParser.new(parsed_board).generate
    result_bucket = storage.bucket RESULT_BUCKET_NAME, skip_lookup: true
    result_bucket.create_file StringIO.new(markdown), "#{file.metadata["email"]}_#{Time.now.to_i}.md"

    # Send email
    # send_email(file.metadata["email"], generated_file.url)
  when :notion
    # TODO: This is next after updating the frontend with the Notion oauth dance
  else
    # Will raise 500 automatically by the functions framework
    raise "No valid method"
  end
end

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
