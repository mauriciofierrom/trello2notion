# frozen_string_literal: true

module Trello2Notion
  module Trello
    # Decorator to format a board
    class JSONExportDecorator
      attr_accessor :board

      def initialize(board)
        @board = board
      end

      def generate
        raise NotImplementedError, "Subclasses must implement the display method"
      end
    end

    Header = Struct.new(:title, :description)

    # Decorator to generate markdown from a board
    class MarkdownDecorator < JSONExportDecorator
      def generate
        ""
      end

      private

      def heading
      end

      def table_of_contents
      end

      def section
      end
    end
  end
end
