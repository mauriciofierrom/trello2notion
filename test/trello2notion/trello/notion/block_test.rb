# frozen_string_literal: true

require "test_helper"

require_relative "block_interface_test"
require_relative "block_subclass_test"

include Trello2Notion::Notion

class StubbedBlock < Block
  def block_to_h = {}
end

class BlockTest < Minitest::Test
  include BlockInterfaceTest

  def setup
    @block = @object = Block.new
    @stubbed_block = StubbedBlock.new
  end

  def test_forces_subclass_to_implement_block_to_h
    assert_raises(NotImplementedError) { @block.block_to_h }
  end

  def test_to_json
    assert_equal @stubbed_block.to_json, {
      object: :block,
      type: "stubbed_block"
    }.to_json
  end
end

class StubbedBlockTest < Minitest::Test
  include BlockSubclassTest

  def setup
    @object = StubbedBlock.new
  end
end
