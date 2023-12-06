# frozen_string_literal: true

class RichTextTest < Minitest::Test
  include Trello2Notion::Notion

  def setup
    text = "Some text"
    rich_text_content = RichTextContent.new(text, nil)
    @rich_text = RichText.new(rich_text_content, nil, text)
  end

  def test_to_h
    assert_equal @rich_text.to_h, {
      type: "text",
      text: {
        content: "Some text",
        url: nil
      },
      annotations: nil,
      plain_text: "Some text"
    }
  end
end
