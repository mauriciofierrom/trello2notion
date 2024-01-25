# frozen_string_literal: true

require "kramdown"
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

  def test_from_elem
    elements = {
      p: Trello2Notion::Markdown::Paragraph,
      blockquote: Trello2Notion::Markdown::BlockQuote,
      codeblock: Trello2Notion::Markdown::CodeBlock,
      header: Trello2Notion::Markdown::Header,
      li: Trello2Notion::Markdown::ListItem,
      ol: Trello2Notion::Markdown::OrderedList,
      ul: Trello2Notion::Markdown::UnorderedList,
      codespan: Trello2Notion::Markdown::CodeSpan,
      em: Trello2Notion::Markdown::Emphasis,
      img: Trello2Notion::Markdown::Image,
      br: Trello2Notion::Markdown::LineBreak,
      a: Trello2Notion::Markdown::Link,
      strong: Trello2Notion::Markdown::Strong,
      text: Trello2Notion::Markdown::Text
    }

    elements.each do |e, c|
      element = Kramdown::Element.new(e)
      assert_instance_of c, Convertible.from_elem(element)
    end
  end

  def test_from_elem_unsupported
    unsupported_element = Kramdown::Element.new(:sike)
    assert_raises(Trello2Notion::Markdown::Convertible::UnsupportedElementError) do
      Convertible.from_elem(unsupported_element)
    end
  end
end

class StubbedConvertibleTest < Minitest::Test
  include ConvertibleInterfaceTest

  def setup
    @object = StubbedConvertible.new
  end
end
