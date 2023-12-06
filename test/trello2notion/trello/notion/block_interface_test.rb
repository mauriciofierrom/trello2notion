module BlockInterfaceTest
  def test_responds_to_to_h
    assert_respond_to(@object, :to_h)
  end

  def test_responds_to_to_json
    assert_respond_to(@object, :to_json)
  end
end
