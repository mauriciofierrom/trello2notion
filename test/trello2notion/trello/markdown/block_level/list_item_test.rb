# frozen_string_literal: true

require "kramdown"
require "test_helper"

class ListItemTest < Minitest::Test
  include Trello2Notion::Markdown
  include Trello2Notion::Notion

  def setup
    li = Kramdown::Element.new(:li)
    p = Kramdown::Element.new(:p)
    p.children = [Kramdown::Element.new(:text, "Plain text")]
    li.children = [p]

    @list_item = @object = ListItem.new(li)

    ol = Kramdown::Element.new(:ol)
    ol.children = [li]
    @ordered_list = OrderedList.new(ol)

    ul = Kramdown::Element.new(:ul)
    ul.children = [li]
    @unordered_list = UnorderedList.new(ul)
  end

  def test_ordered_list_item
    rich_text = RichText.basic("Plain text")
    numbered_item = NumberedListItem.new(rich_text: [rich_text])
    _extra_blocks, list_items = @list_item.convert(@ordered_list)
    assert_equal list_items[0].to_json, numbered_item.to_json
  end

  def test_unordered_list_item
    rich_text = RichText.basic("Plain text")
    bulleted_item = BulletedListItem.new(rich_text: [rich_text])
    _extra_blocks, list_items = @list_item.convert(@unordered_list)
    assert_equal list_items[0].to_json, bulleted_item.to_json
  end

  def test_list_item_with_image
    md = "- Tux is the linux mascot ![Tux, the Linux mascot](/assets/images/tux.png)"
    element = Kramdown::Parser::Markdown.parse(md)[0].children[0].children[0]

    rich_text = RichText.basic("Tux is the linux mascot ")
    bulleted_item = BulletedListItem.new(rich_text: [rich_text])

    notion_image = Trello2Notion::Notion::Image.basic(src: "/assets/images/tux.png")
    extra_blocks, list_items = Convertible.from_elem(element).convert(@unordered_list)

    assert_equal list_items[0].to_json, bulleted_item.to_json
    assert_equal extra_blocks.to_json, [notion_image].to_json
  end

  def test_list_item_with_image_link
    md = "- An alligator link image [![Alt text](https://assets.digitalocean.com/articles/alligator/boo.svg)](https://digitalocean.com)"
    element = Kramdown::Parser::Markdown.parse(md)[0].children[0].children[0]

    text = RichText.basic("An alligator link image ")
    link_text = RichText.link(content: "Alt text", link: "https://digitalocean.com")
    rich_text = [text, link_text]
    bulleted_item = BulletedListItem.new(rich_text: rich_text)
    notion_image = Trello2Notion::Notion::Image.basic(src: "https://assets.digitalocean.com/articles/alligator/boo.svg")

    extra_blocks, list_items = Convertible.from_elem(element).convert(@unordered_list)

    assert_equal list_items[0].to_json, bulleted_item.to_json
    assert_equal extra_blocks.to_json, [notion_image].to_json
  end

  def test_list_item_with_nested_item
    md = "- some\n    - other"
    element = Kramdown::Parser::Markdown.parse(md)[0].children[0].children[0]

    children = [BulletedListItem.new(rich_text: [RichText.basic("other")])]
    bulleted_item = BulletedListItem.new(rich_text: [RichText.basic("some\n")], children:)

    _extra, list_items = Convertible.from_elem(element).convert(@unordered_list)

    assert_equal list_items[0].to_json, bulleted_item.to_json
  end
end
