# frozen_string_literal: true

module Trello2Notion
  module Trello
    # Decorator to format a board
    class JSONExportDecorator
      attr_reader :board

      def initialize(board)
        @board = board
      end

      def generate
        raise NotImplementedError, "Subclasses must implement the display method"
      end
    end
  end
end
