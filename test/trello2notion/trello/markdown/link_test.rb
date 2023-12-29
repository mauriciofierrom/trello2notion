# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "convertible_interface_test"

class LinkTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    @image_url = "https://imagesite.com/img.jpg"
    element = Kramdown::Element.new(:a, nil, "href" => @image_url)
    @link = @object = Link.new(element)
  end

  def test_convert_text_link
    text_link = @link.clone
    text_link.element.children << Kramdown::Element.new(:text, "link text")
    text_link.element.attr["href"] = "https://www.google.com"
    assert_equal text_link.convert[0].to_json, RichText.link(content: "link text", link: "https://www.google.com").to_json
  end

  def test_convert_image_link_with_alt_text
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => @image_url, "alt" => "Alt text")
    img_link.element.children << img

    assert_image_link(img_link, "Alt text")
  end

  def test_convert_image_link_with_title
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => @image_url, "title" => "Image title")
    img_link.element.children << img

    assert_image_link(img_link, "Image title")
  end

  def test_convert_image_link_without_text
    img_link = @link.clone
    img = Kramdown::Element.new(:img, nil, "src" => @image_url)
    img_link.element.children << img

    assert_image_link(img_link, "Image link")
  end

  def test_raise_error_unsupported_link
    unsupported_child = Kramdown::Element.new(:some)
    unsupported = @link.clone
    unsupported.element.children << unsupported_child

    assert_raises(Link::UnsupportedLinkError) do
      unsupported.convert
    end
  end

  private

  def assert_image_link(img_link, text)
    image, rich_text = *img_link.convert

    assert_equal rich_text.to_json, RichText.link(content: text, link: @image_url).to_json
    assert_instance_of(Trello2Notion::Notion::Image, image)
  end
end
