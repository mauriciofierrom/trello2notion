# frozen_string_literal: true

require "kramdown"
require "test_helper"

class UnorderedListTest < Minitest::Test
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    li = Kramdown::Element.new(:li)
    p = Kramdown::Element.new(:p)
    p.children = [Kramdown::Element.new(:text, "Plain text")]
    li.children = [p]

    ul = Kramdown::Element.new(:ul)
    ul.children = [li]

    @unordered_list = @object = UnorderedList.new(ul)
  end

  def test_convert
    bulleted_list_item = BulletedListItem.new(rich_text: [RichText.basic("Plain text")])
    _extra, list_items = @unordered_list.convert

    assert_equal list_items[0].to_json, bulleted_list_item.to_json
  end
end
