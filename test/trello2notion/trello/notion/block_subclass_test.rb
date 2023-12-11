# frozen_string_literal: true

module BlockSubclassTest
  def test_respond_to_post_init
    assert_respond_to(@object, :post_init)
  end

  def test_respond_to_block_to_h
    assert_respond_to(@object, :block_to_h)
  end
end
