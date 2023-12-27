# frozen_string_literal: true

require "test_helper"
require_relative "block_interface_test"
require_relative "block_subclass_test"

class BookmarkTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    rich_text = RichText.new(RichTextContent.new("Google", nil), nil, "Google")
    @bookmark = @object = Bookmark.new(caption: [rich_text], url: "https://www.google.com")
  end

  def test_to_json
    assert_equal @bookmark.to_json, {
      object: "object",
      type: "bookmark",
      bookmark: {
        caption: [
          type: "text",
          text: {
            content: "Google",
            link: nil
          },
          annotations: nil,
          plain_text: "Google"
        ],
        url: "https://www.google.com"
      }
    }.to_json
  end
end
