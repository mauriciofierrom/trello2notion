# frozen_string_literal: true

require_relative "convertible"
require_relative "../notion/rich_text"

module Trello2Notion
  module Markdown
    # A Markdown hard line break
    class LineBreak
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert
        Trello2Notion::Notion::RichText.basic("\n\n")
      end
    end
  end
end
