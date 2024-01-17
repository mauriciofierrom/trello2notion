# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "../convertible_interface_test"

class EmphasisTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    text = "have"
    content = RichTextContent.new(text)
    annotations = default_annotations
    annotations.italic = true
    @rich_text = RichText.new(content, annotations, text)

    element = Kramdown::Element.new(:em, "have")
    @emphasis = @object = Emphasis.new(element)
  end

  def convert
    assert_equal @emphasis.convert.to_json, @rich_text.to_json
  end
end
