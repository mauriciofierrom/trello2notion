# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class TextTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    element = Kramdown::Element.new(:p, "text in the element")
    @text = @object = Text.new(element)
  end

  def test_convert
    assert_equal @text.convert.to_json, RichText.basic("text in the element").to_json
  end
end
