# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

class DividerTest < Minitest::Test
  include Trello2Notion::Notion

  include BlockInterfaceTest
  include BlockSubclassTest

  def setup
    @divider = @object = Divider.new
  end

  def test_to_json
    assert_equal @divider.to_json, {
      object: "block",
      type: "divider",
      divider: {}
    }.to_json
  end
end
