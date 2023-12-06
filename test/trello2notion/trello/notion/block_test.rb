# frozen_string_literal: true

require "trello2notion/trello/notion"
include Trello2Notion::Notion

class StubbedBlock < Block
  def local_to_h(hash) = hash
end


class BlockTest < Minitest::Test
  include BlockInterfaceTest

  def setup
    @block = @object = Block.new
    @stubbed_block = StubbedBlock.new
  end

  def test_forces_subclass_to_implement_local_to_h
    assert_raises(NotImplementedError) { @block.local_to_h({}) }
  end

  def test_to_json
    assert_equal @stubbed_block.to_json, {
      object: :object,
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
