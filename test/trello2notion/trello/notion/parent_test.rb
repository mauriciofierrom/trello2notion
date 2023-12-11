# frozen_string_literal: true

require "test_helper"
require_relative "json_convertible_test"
require_relative "parent_subclass_test"

include Trello2Notion::Notion

class StubbedParent < Parent
  def parent_to_h = {}
end

class ParentTest < Minitest::Test
  include JsonConvertibleInterfaceTest
  def setup
    @parent = @object = Parent.new
    @stubbed_parent = StubbedParent.new
  end

  def test_page_parent_to_json
    assert_equal PageParent.new(page_id: "123").to_json, {
      type: "page_id",
      page_id: "123"
    }.to_json
  end

  def test_to_json
    assert_equal @stubbed_parent.to_json, {
      type: nil
    }.to_json
  end

  def test_forces_subclass_to_implement_parent_to_h
    assert_raises(NotImplementedError) { @parent.parent_to_h }
  end
end

class StubbedParentTest < Minitest::Test
  include ParentSubclassTest

  def setup
    @object = StubbedParent.new
  end
end
