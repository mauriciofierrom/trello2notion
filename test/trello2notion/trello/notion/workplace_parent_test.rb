# frozen_string_literal: true

require "test_helper"

require_relative "parent_interface_test"
require_relative "parent_subclass_test"

class WorkspaceParentTest < Minitest::Test
  include Trello2Notion::Notion

  include ParentInterfaceTest
  include ParentSubclassTest

  def setup
    @workspace_parent = @object = WorkspaceParent.new
  end

  def test_to_json
    assert_equal @workspace_parent.to_json, {
      type: "workspace",
      workspace: true
    }.to_json
  end
end
