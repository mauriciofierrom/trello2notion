# frozen_string_literal: true

require "kramdown"
require "test_helper"

require_relative "../convertible_interface_test"

class MarkdownImageTest < Minitest::Test
  include ConvertibleInterfaceTest
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    img_element = Kramdown::Element.new(:img, nil, "src" => "https://www.whatimage.com/some.png")
    @image = @object = Trello2Notion::Markdown::Image.new(img_element)
  end

  def test_convert
    external_file = Trello2Notion::Notion::ExternalFile.new(url: "https://www.whatimage.com/some.png")
    notion_image = Trello2Notion::Notion::Image.new(file: external_file)
    assert_equal @image.convert.to_json, notion_image.to_json
  end
end
