# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "../convertible_interface_test"

class MarkdownParagraphTest < Minitest::Test
  include Trello2Notion::Markdown
  include ConvertibleInterfaceTest

  def setup
    paragraph_element = Kramdown::Element.new(:p)
    text = Kramdown::Element.new(:text, "A paragraph")
    paragraph_element.children = [text]
    @paragraph = @object = Trello2Notion::Markdown::Paragraph.new(paragraph_element)
  end

  def test_convert_no_parent
    rich_text = [Trello2Notion::Notion::RichText.basic("A paragraph")]
    _images, paragraph = @paragraph.convert
    assert_equal paragraph.to_json,
                 Trello2Notion::Notion::Paragraph.new(rich_text:).to_json
  end

  def test_convert_with_parent
    rich_text = [Trello2Notion::Notion::RichText.basic("A paragraph")]
    parent = Convertible.from_elem(Kramdown::Element.new(:li))
    _images, paragraph_text = @paragraph.convert(parent)
    assert_equal paragraph_text.to_json, rich_text.to_json
  end

  def test_convert_with_image
    text = Kramdown::Element.new(:text, "A paragraph with an image")
    paragraph_element = Kramdown::Element.new(:p)
    image = Kramdown::Element.new(:img, nil, { "src" => "/assets/images/tux.png" })
    paragraph_element.children = [image, text]
    paragraph = Convertible.from_elem(paragraph_element)

    rich_text = [Trello2Notion::Notion::RichText.basic("A paragraph with an image")]
    parent = Convertible.from_elem(Kramdown::Element.new(:li))

    external_file = Trello2Notion::Notion::ExternalFile.new(url: "/assets/images/tux.png")
    notion_image = Trello2Notion::Notion::Image.new(file: external_file)

    images, rich_text_result = paragraph.convert(parent)

    assert_equal images[0].to_json, notion_image.to_json
    assert_equal rich_text_result.to_json, rich_text.to_json
  end
end
