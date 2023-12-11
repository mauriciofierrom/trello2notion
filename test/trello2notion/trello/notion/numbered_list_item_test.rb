# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class NumberedListItemTest < Minitest::Test
  include Trello2Notion::Notion
  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    rich_text =
      RichText.new(RichTextContent.new("A list item", nil), nil, "A list item")
    @numbered_list_item = @object = NumberedListItem.new(rich_text: [rich_text])
  end

  def test_to_json
    assert_equal @numbered_list_item.to_json, {
      object: "object",
      type: "numbered_list_item",
      numbered_list_item: {
        rich_text: [
          type: "text",
          text: {
            content: "A list item",
            url: nil
          },
          annotations: nil,
          plain_text: "A list item"
        ],
        color: "default",
        children: []
      }
    }.to_json
  end
end
