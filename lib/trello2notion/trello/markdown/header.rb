# frozen_string_literal: true

require_relative "convertible"
require_relative "../notion/heading"

module Trello2Notion
  module Markdown
    # Header Kramdown element
    class Header
      include Convertible
      include Trello2Notion::Notion

      MODULE_PREFIX = "Trello2Notion::Notion::"

      def initialize(element)
        @element = element
      end

      def convert
        rich_text = RichText.basic_rich_text(extract_text)
        determine_heading.new(rich_text: [rich_text])
      end

      private

      def level
        [@element.options[:level], 3].min
      end

      def determine_heading
        Object.const_get("#{MODULE_PREFIX}Heading#{level}")
      end
    end
  end
end
