# frozen_string_literal: true

require "test_helper"

class PageTest < Minitest::Test
  include Trello2Notion::Notion

  def setup
    workspace_parent = WorkspaceParent.new
    rich_text = RichText.new(RichTextContent.new("something in the way she moves", nil), nil, "something in the way she moves")
    paragraph = @object = Paragraph.new(rich_text: [rich_text])
    @page = Page.new(title: "A test page", parent: workspace_parent, children: [paragraph])
  end

  def test_to_json
    assert_equal @page.to_json, {
      cover: nil,
      icon: nil,
      properties: {
        title: [
          {
            text: {
              content: "A test page"
            }
          }
        ]
      },
      parent: {
        type: "workspace",
        workspace: true
      },
      children: [
        {
          object: "block",
          type: "paragraph",
          paragraph: {
            rich_text: [
              type: "text",
              text: {
                content: "something in the way she moves",
                link: nil
              },
              annotations: {},
              plain_text: "something in the way she moves"
            ]
          }
        }
      ]
    }.to_json
  end
end
