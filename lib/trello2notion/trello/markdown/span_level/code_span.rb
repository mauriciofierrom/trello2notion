# frozen_string_literal: true

require_relative "../convertible"
require_relative "../../notion/rich_text"

module Trello2Notion
  module Markdown
    # A Markdown codespan
    class CodeSpan
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert
        # @element.value
        content = RichTextContent.new(@element.value)
        annotations = default_annotations
        annotations.code = true

        RichText.new(content, annotations, @element.value)
      end
    end
  end
end
