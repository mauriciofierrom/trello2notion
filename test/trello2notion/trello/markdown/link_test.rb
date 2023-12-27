# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "convertible_interface_test"

class LinkTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    element = Kramdown::Element.new(:a, nil, "href" => "https://www.google.com")
    @link = @object = Link.new(element)
  end

  def test_convert_text_link
    text_link = @link.clone
    text_link.element.children << Kramdown::Element.new(:text, "link text")
    assert_equal text_link.convert[0].to_json, RichText.link(content: "link text", link: "https://www.google.com").to_json
  end

  def test_convert_image_link_with_alt_text
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => "", "alt" => "Alt text")
    img_link.element.children << img

    assert_equal img_link.convert[0].to_json, RichText.link(content: "Alt text", link: "https://www.google.com").to_json
  end

  def test_convert_image_link_with_title
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => "", "title" => "Image title")
    img_link.element.children << img

    assert_equal img_link.convert[0].to_json, RichText.link(content: "Image title", link: "https://www.google.com").to_json
  end

  def test_convert_image_link_without_text
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => "")
    img_link.element.children << img

    assert_equal img_link.convert[0].to_json, RichText.link(content: "Image link", link: "https://www.google.com").to_json
  end

  def test_raise_error_unsupported_link
    unsupported_child = Kramdown::Element.new(:some)
    unsupported = @link.clone
    unsupported.element.children << unsupported_child

    assert_raises(Link::UnsupportedLinkError) do
      unsupported.convert
    end
  end
end
