# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "../convertible_interface_test"

class BlankTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    @empty_paragraph = Trello2Notion::Notion::Paragraph.new(rich_text: [RichText.empty])

    element = Kramdown::Element.new(:blank, "\n")
    @blank = @object = Blank.new(element)

  end

  def test_convert
    assert_equal @blank.convert.first.to_json, @empty_paragraph.to_json
  end
end
