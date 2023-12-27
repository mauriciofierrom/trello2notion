# frozen_string_literal: true

require_relative "convertible"

module Trello2Notion
  module Markdown
    # A markdown text span-level element
    class Text
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert
        Trello2Notion::Notion::RichText.basic(@element.value)
      end
    end
  end
end
