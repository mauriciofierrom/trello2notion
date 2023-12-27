# frozen_string_literal: true

require "test_helper"
require_relative "block_interface_test"
require_relative "block_subclass_test"

class ParagraphTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    rich_text = RichText.new(RichTextContent.new("something in the way she moves", nil), nil, "something in the way she moves")
    @paragraph = @object = Paragraph.new(rich_text: [rich_text])
  end

  def test_to_json
    assert_equal @paragraph.to_json, {
      object: "object",
      type: "paragraph",
      paragraph: {
        rich_text: [
          type: "text",
          text: {
            content: "something in the way she moves",
            link: nil
          },
          annotations: nil,
          plain_text: "something in the way she moves"
        ]
      }
    }.to_json
  end
end
