# frozen_string_literal: true

module Trello2Notion
  module Markdown
    # Convertible markdown elements
    module Convertible
      attr_accessor :element

      def extract_text
        @element
          .children
          .filter_map { |e| e.value if e.type == :text }
          .join(" ")
      end

      def convert
        raise NotImplementedError, "Class #{self.class} must implement method #convert"
      end
    end
  end
end
