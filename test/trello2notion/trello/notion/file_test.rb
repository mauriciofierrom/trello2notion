# frozen_string_literal: true

require "test_helper"

class NotionFileTest < Minitest::Test
  include Trello2Notion::Notion

  def test_notion_file_to_json
    expiry_time = "2020-03-17T19:10:04.968Z"
    notion_file = NotionFile.new(
      url: "https://some.com/1.jpg",
      expiry_time:
    )

    assert_equal notion_file.to_json, {
      type: "file",
      file: {
        url: "https://some.com/1.jpg",
        expiry_time: "2020-03-17T19:10:04.968Z"
      }
    }.to_json
  end

  def test_external_file_to_json
    external_file = ExternalFile.new(url: "https://some.com/1.jpg")
    assert_equal external_file.to_json, {
      type: "external",
      external: {
        url: "https://some.com/1.jpg"
      }
    }.to_json
  end
end
