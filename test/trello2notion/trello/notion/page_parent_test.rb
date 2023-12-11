# frozen_string_literal: true

require "test_helper"

require_relative "parent_interface_test"
require_relative "parent_subclass_test"

class PageParentTest < Minitest::Test
  include Trello2Notion::Notion

  include ParentInterfaceTest
  include ParentSubclassTest

  def setup
    @page_parent = @object = PageParent.new(page_id: "123")
  end

  def test_to_json
    assert_equal @page_parent.to_json, {
      type: "page_id",
      page_id: "123"
    }.to_json
  end
end
