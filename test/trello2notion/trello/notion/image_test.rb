# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class ImageTest < Minitest::Test
  include Trello2Notion::Notion
  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    file = ExternalFile.new(url: "https://some.com/image.png")
    @image = @object = Image.new(file:)
  end

  def test_to_json
    assert_equal @image.to_json, {
      object: "block",
      type: "image",
      image: {
        type: "external",
        external: {
          url: "https://some.com/image.png"
        }
      }
    }.to_json
  end

  def test_unsupported_image_type_error
    assert_raises UnsupportedImageTypeError do
      file = ExternalFile.new(url: "https://some.com/image.webp")
      Image.new(file:)
    end
  end
end
