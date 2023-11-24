# frozen_string_literal: true

require "test_helper"
require "redcarpet"
require "trello2notion/trello/decorators/json_export_decorator"
require "trello2notion/trello/trello"

class MarkdownDecoratorTest < Minitest::Test
  include Trello2Notion::Trello

  def test_markdown_contents
    markdown_decorator = MarkdownDecorator.new(board)

    generated_markdown = File.read("test/fixtures/generated.md")

    assert_equal generated_markdown, markdown_decorator.generate
  end

  def test_markdown_valid
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    markdown_decorator = MarkdownDecorator.new(board)

    markdown.render(markdown_decorator.generate)
  end

  private

  def board
    now = Time.now
    member = BoardMember.new("1,2,3", "Member 1")
    comment1 = Comment.new("This is a comment which is content in the thingy", member, now)
    comment2 = Comment.new("This is another comment which is content in the thingy", member, now)
    card1 = Card.new("123",
                     "Section 1",
                     "Description of section 1. Ideally this would be some...",
                     now, [comment1])
    card2 = Card.new("321",
                     "Section 2",
                     "Description of section 2. Ideally this would be some...",
                     now, [comment2])

    Board.new("Test board", [card1, card2])
  end
end
