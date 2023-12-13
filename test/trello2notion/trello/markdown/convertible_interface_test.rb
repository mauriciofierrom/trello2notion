# frozen_string_literal: true

module ConvertibleInterfaceTest
  def test_responds_to_extract_text
    assert_respond_to(@object, :extract_text)
  end

  def test_responds_to_convert
    assert_respond_to(@object, :convert)
  end
end
