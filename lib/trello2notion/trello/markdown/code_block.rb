# frozen_string_literal: true

require_relative "convertible"

module Trello2Notion
  module Markdown
    # A Markdown block quote
    class CodeBlock
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert
        rich_text = Trello2Notion::Notion::RichText.basic(extract_text)
        Trello2Notion::Notion::Code.new(rich_text: [rich_text])
      end
    end
  end
end
