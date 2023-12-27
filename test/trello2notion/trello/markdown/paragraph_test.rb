# frozen_string_literal: true

require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class MarkdownParagraphTest < Minitest::Test
  include ConvertibleInterfaceTest

  def setup
    paragraph_element = Minitest::Mock.new
    paragraph_element.expect(:children, [StubbedTextElement.new("A paragraph")])
    @paragraph = @object = Trello2Notion::Markdown::Paragraph.new(paragraph_element)
  end

  def test_convert
    rich_text = Trello2Notion::Notion::RichText.basic("A paragraph")
    assert_equal @paragraph.convert.to_json,
                 Trello2Notion::Notion::Paragraph.new(rich_text: [rich_text]).to_json
  end
end
