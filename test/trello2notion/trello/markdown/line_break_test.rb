# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class LineBreakTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    element = Kramdown::Element.new(:br)
    @line_break = @object = LineBreak.new(element)
  end

  def test_convert
    assert_equal @line_break.convert.to_json, RichText.basic("\n\n").to_json
  end
end
