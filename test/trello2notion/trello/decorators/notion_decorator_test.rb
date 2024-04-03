# frozen_string_literal: true

require "test_helper"
require "kramdown"
require "trello2notion/trello"
require "trello2notion/trello/notion"
require "trello2notion/trello/decorators"

class NotionDecoratorTest < Minitest::Test
  include Trello2Notion::Trello
  include Trello2Notion::Notion

  def test_notion_page
    notion_decorator = NotionDecorator.new(board)

    page = Page.new(title: "Test Board", parent: WorkspaceParent.new)
    card_page1 = Page.new(title: "Section 1", parent: PageParent.new(page_id: "123"))
    card_page1.children = [
      Paragraph.new(rich_text: [RichText.basic("Description of section 1")]),
      Paragraph.new(rich_text: [RichText.empty]),
      Paragraph.new(rich_text: [RichText.basic("Something else")]),
      Paragraph.new(rich_text: [RichText.basic("First comment")])
    ]
    card_page2 = Page.new(title: "Section 2", parent: PageParent.new(page_id: "123"))
    card_page2.children = [
      Paragraph.new(rich_text: [RichText.basic("Description of section 2")]),
      Paragraph.new(rich_text: [RichText.basic("Second comment")])
    ]

    board_page, subpages_builder = notion_decorator.generate

    assert_equal board_page.to_json, page.to_json
    assert_equal subpages_builder.call(page_id: "123").map(&:to_json), [card_page1, card_page2].map(&:to_json)
  end

  private

  def board
    now = Time.now
    member = BoardMember.new("1,2,3", "Member 1")
    comment1 = Comment.new("First comment", member, now)
    comment2 = Comment.new("Second comment", member, now)
    card1 = Card.new("123",
                     "Section 1",
                     "Description of section 1\n\nSomething else",
                     now, [comment1])
    card2 = Card.new("321",
                     "Section 2",
                     "Description of section 2",
                     now, [comment2])

    Board.new("Test Board", [card1, card2])
  end
end
