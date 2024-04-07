# frozen_string_literal: true

require "test_helper"
require "kramdown"

require_relative "../convertible_interface_test"

class CodeBlockTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    element = Kramdown::Element.new(:codeblock, "let x = 12\n in x + 5")
    @code_block = @object = CodeBlock.new(element)
  end

  def test_convert
    rich_text = RichText.basic("let x = 12\n in x + 5")
    assert_equal @code_block.convert.to_json, Code.new(rich_text: [rich_text]).to_json
  end
end
