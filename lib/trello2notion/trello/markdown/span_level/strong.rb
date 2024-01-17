# frozen_string_literal: true

require_relative "../convertible"
require_relative "../../notion/rich_text"

module Trello2Notion
  module Markdown
    # A Markdown strong text
    class Strong
      include Convertible
      include Trello2Notion::Notion

      def initialize(element)
        @element = element
      end

      def convert
        content = RichTextContent.new(@element.value)
        annotations = default_annotations
        annotations.bold = true

        RichText.new(content, annotations, @element.value)
      end
    end
  end
end
