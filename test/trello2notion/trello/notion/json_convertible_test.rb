# frozen_string_literal: true

require "test_helper"
require_relative "json_convertible_interface_test"

include Trello2Notion::Notion

class StubbedJsonConvertible
  include JsonConvertible
end

class JsonConvertibleTest < Minitest::Test
  def test_forces_includer_to_implement_local_to_h
    assert_raises(NotImplementedError) do
      StubbedJsonConvertible.new.local_to_h
    end
  end
end

class StubbedJsonConvertibleTest < Minitest::Test
  include JsonConvertibleInterfaceTest

  def setup
    @object = StubbedJsonConvertible.new
  end
end
