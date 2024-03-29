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
        text = @element.children.map(&:value).join
        content = RichTextContent.new(text)
        annotations = default_annotations
        annotations.bold = true

        RichText.new(content, annotations, text)
      end
    end
  end
end
