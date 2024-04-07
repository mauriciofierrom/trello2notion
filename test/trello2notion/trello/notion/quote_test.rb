# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class QuoteTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    rich_text = RichText.new(RichTextContent.new("Paragraph", nil), nil, "Paragraph")
    paragraph = Paragraph.new(rich_text: [rich_text])
    @quote = @object = Quote.new(rich_text: [rich_text], children: [paragraph])
  end

  def test_to_json
    assert_equal @quote.to_json, {
      object: "block",
      type: "quote",
      quote: {
        rich_text: [
          type: "text",
          text: {
            content: "Paragraph",
            link: nil
          },
          annotations: {},
          plain_text: "Paragraph"
        ],
        color: "default",
        children: [{
          object: "block",
          type: "paragraph",
          paragraph: {
            rich_text: [
              type: "text",
              text: {
                content: "Paragraph",
                link: nil
              },
              annotations: {},
              plain_text: "Paragraph"
            ]
          }
        }]
      }
    }.to_json
  end
end
