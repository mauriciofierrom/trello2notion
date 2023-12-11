# frozen_string_literal: true

require "test_helper"

class ParentTest < Minitest::Test
  include Trello2Notion::Notion

  def test_workspace_parent_to_json
    assert_equal WorkspaceParent.new.to_json, {
      type: "workspace",
      workspace: true
    }.to_json
  end

  def test_page_parent_to_json
    assert_equal PageParent.new(page_id: "123").to_json, {
      type: "page_id",
      page_id: "123"
    }.to_json
  end
end
