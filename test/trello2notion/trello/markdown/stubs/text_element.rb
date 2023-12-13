# frozen_string_literal: true

class StubbedTextElement
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def value
    @text
  end

  def type
    :text
  end
end
