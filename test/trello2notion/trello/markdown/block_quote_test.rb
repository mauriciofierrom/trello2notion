# frozen_string_literal: true

require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class BlockQuoteTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    block_quote_element = Minitest::Mock.new
    block_quote_element.expect(:children, [StubbedTextElement.new("A quote")])
    @block_quote = @object = BlockQuote.new(block_quote_element)
  end

  def test_convert
    rich_text = RichText.basic_rich_text("A quote")
    assert_equal @block_quote.convert.to_json, Quote.new(rich_text: [rich_text]).to_json
  end
end
