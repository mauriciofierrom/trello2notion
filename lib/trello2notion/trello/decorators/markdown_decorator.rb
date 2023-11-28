# frozen_string_literal: true

require_relative "json_export_decorator"

module Trello2Notion
  module Trello
    # Decorator to generate markdown from a board
    class MarkdownDecorator < JSONExportDecorator
      SECTION_SEPARATOR = "\n\n"

      def generate
        [
          heading,
          table_of_contents,
          sections
        ].reject(&:empty?)
          .join(SECTION_SEPARATOR)
      end

      private

      def heading
        "# #{@board.name}"
      end

      def table_of_contents
        links = @board.cards.map do |card|
          "- [#{card.name}](#{section_to_anchor(card.name)})"
        end.join("\n")

        links.empty? ? "" : links.prepend("## Contents\n\n")
      end

      def sections
        @board.cards.map do |card|
          section(card) + section_content(card)
        end
      end

      def section(card)
        "## #{card.name}\n\n#{card.description}"
      end

      def section_content(card)
        text = card.comments.map(&:text)
        text.empty? ? "" : "\n\n#{text.join("\n\n")}"
      end

      def section_to_anchor(section)
        section
          .scan(/\w+/)
          .join("-")
          .downcase
          .prepend("#")
      end
    end
  end
end
