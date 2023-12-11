# frozen_string_literal: true

module ParentSubclassTest
  def test_respond_to_post_init
    assert_respond_to(@object, :post_init)
  end

  def test_respond_to_parent_to_h
    assert_respond_to(@object, :parent_to_h)
  end
end
