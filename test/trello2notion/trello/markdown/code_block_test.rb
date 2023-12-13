# frozen_string_literal: true

require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class CodeBlockTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    code_block_element = Minitest::Mock.new
    code_block_element.expect(:children, [StubbedTextElement.new("let x = 12\n in x + 5")])
    @code_block = @object = CodeBlock.new(code_block_element)
  end

  def test_convert
    rich_text = RichText.basic_rich_text("let x = 12\n in x + 5")
    assert_equal @code_block.convert.to_json, Code.new(rich_text: [rich_text]).to_json
  end
end
