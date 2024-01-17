# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "../convertible_interface_test"

class CodeSpanTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    text = "let x = y + 1"
    content = RichTextContent.new(text)
    annotations = default_annotations
    annotations.code = true

    @rich_text = RichText.new(content, annotations, text)

    element = Kramdown::Element.new(:codespan, "let x = y + 1")
    @codespan = @object = CodeSpan.new(element)
  end

  def test_convert
    assert_equal @codespan.convert.to_json, @rich_text.to_json
  end
end
