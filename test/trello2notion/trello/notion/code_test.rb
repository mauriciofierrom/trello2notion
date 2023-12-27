# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class CodeTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    caption = RichText.new(RichTextContent.new("Some caption", nil), nil, "Some caption")
    rich_text = RichText.new(RichTextContent.new("x :: Int\nx = 12", nil), nil, "x :: Int\nx = 12")
    @code = @object = Code.new(caption: [caption], rich_text: [rich_text], language: LANGUAGE[:haskell])
  end

  def test_to_json
    assert_equal @code.to_json, {
      object: "object",
      type: "code",
      code: {
        caption: [
          type: "text",
          text: {
            content: "Some caption",
            link: nil
          },
          annotations: nil,
          plain_text: "Some caption"
        ],
        rich_text: [
          type: "text",
          text: {
            content: "x :: Int\nx = 12",
            link: nil
          },
          annotations: nil,
          plain_text: "x :: Int\nx = 12"
        ],
        language: "haskell"
      }
    }.to_json
  end
end
