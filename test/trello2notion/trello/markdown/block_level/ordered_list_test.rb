# frozen_string_literal: true

require "kramdown"
require "test_helper"

class OrderedListTest < Minitest::Test
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    li = Kramdown::Element.new(:li)
    p = Kramdown::Element.new(:p)
    p.children = [Kramdown::Element.new(:text, "Plain text")]
    li.children = [p]

    ol = Kramdown::Element.new(:ol)
    ol.children = [li]

    @ordered_list = @object = OrderedList.new(ol)
  end

  def test_convert
    numbered_list_item = NumberedListItem.new(rich_text: [RichText.basic("Plain text")])
    _extra, list_items = @ordered_list.convert

    assert_equal list_items[0].to_json, numbered_list_item.to_json
  end
end
