# frozen_string_literal: true

require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

class HeaderTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Notion
  include Trello2Notion::Markdown

  def setup
    header_element = Minitest::Mock.new
    header_element.expect(:options, { level: 1 })
    header_element.expect(:children, [StubbedTextElement.new("Header content")])

    @rich_text = RichText.basic_rich_text("Header content")
    @object = Header.new(header_element)
  end

  def test_convert_heading1
    header_element = Minitest::Mock.new
    header_element.expect(:options, { level: 1 })
    header_element.expect(:children, [StubbedTextElement.new("Header content")])

    header = Header.new(header_element)
    assert_equal header.convert.to_json, Heading1.new(rich_text: [@rich_text]).to_json
  end

  def test_convert_heading2
    header_element = Minitest::Mock.new
    header_element.expect(:options, { level: 2 })
    header_element.expect(:children, [StubbedTextElement.new("Header content")])

    header = Header.new(header_element)
    assert_equal header.convert.to_json, Heading2.new(rich_text: [@rich_text]).to_json
  end

  def test_convert_heading3
    header_element = Minitest::Mock.new
    header_element.expect(:options, { level: 3 })
    header_element.expect(:children, [StubbedTextElement.new("Header content")])

    header = Header.new(header_element)
    assert_equal header.convert.to_json, Heading3.new(rich_text: [@rich_text]).to_json
  end

  def test_convert_header_level_greater_than_3
    header_element = Minitest::Mock.new
    header_element.expect(:options, { level: 5 })
    header_element.expect(:children, [StubbedTextElement.new("Header content")])

    header = Header.new(header_element)
    assert_equal header.convert.to_json, Heading3.new(rich_text: [@rich_text]).to_json
  end
end
