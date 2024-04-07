# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class HeadingTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    rich_text = RichText.new(RichTextContent.new("Title", nil), nil, "Title")
    @heading1 = @object = Heading1.new(rich_text: [rich_text])
  end

  def test_to_json
    assert_equal @heading1.to_json, {
      object: "block",
      type: "heading_1",
      heading_1: {
        rich_text: [
          type: "text",
          text: {
            content: "Title",
            link: nil
          },
          annotations: {},
          plain_text: "Title"
        ],
      color: "default",
      is_toggleable: false
      }
    }.to_json
  end
end
