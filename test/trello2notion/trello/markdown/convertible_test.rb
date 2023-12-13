# frozen_string_literal: true

require "test_helper"

require_relative "convertible_interface_test"
require_relative "stubs/text_element"

include Trello2Notion::Markdown

class StubbedElement
  def children
    [
      StubbedTextElement.new("Test text")
    ]
  end
end

class StubbedConvertible
  include Convertible

  def initialize
    @element = StubbedElement.new
  end
end

class ConvertibleTest < Minitest::Test
  def test_forces_includer_to_implement_convert
    assert_raises(NotImplementedError) do
      StubbedConvertible.new.convert
    end
  end

  def test_extract_text
    assert_equal StubbedConvertible.new.extract_text, "Test text"
  end
end

class StubbedConvertibleTest < Minitest::Test
  include ConvertibleInterfaceTest

  def setup
    @object = StubbedConvertible.new
  end
end
