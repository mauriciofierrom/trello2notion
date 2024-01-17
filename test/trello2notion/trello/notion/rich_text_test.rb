# frozen_string_literal: true

require "test_helper"

require_relative "json_convertible_interface_test"

class RichTextTest < Minitest::Test
  include Trello2Notion::Notion
  include JsonConvertibleInterfaceTest

  def setup
    text = "Some text"
    rich_text_content = RichTextContent.new(text, nil)
    @rich_text = @object = RichText.new(rich_text_content, nil, text)
  end

  def test_to_h_without_link
    assert_equal @rich_text.to_h, {
      type: "text",
      text: {
        content: "Some text",
        link: nil
      },
      annotations: nil,
      plain_text: "Some text"
    }
  end

  def test_to_h_with_link
    with_link = @rich_text.clone
    with_link.text.link = "https://motherfuckingwebsite.com"
    assert_equal with_link.to_h, {
      type: "text",
      text: {
        content: "Some text",
        link: {
          url: "https://motherfuckingwebsite.com"
        }
      },
      annotations: nil,
      plain_text: "Some text"
    }
  end

  def test_default_annotations
    annotations = default_annotations
    refute annotations.bold
    refute annotations.italic
    refute annotations.strikethrough
    refute annotations.underline
    refute annotations.code
    assert_equal annotations.color, COLOR[:default]
  end
end
