# frozen_string_literal: true

module Trello2Notion
  module Markdown
    # Convertible markdown elements
    module Convertible
      attr_accessor :element

      class UnsupportedElementError < StandardError; end

      def extract_text
        @element
          .children
          .filter_map { |e| e.value if e.type == :text }
          .join(" ")
      end

      def convert
        raise NotImplementedError, "Class #{self.class} must implement method #convert"
      end
      def self.from_elem(element)
        case element.type
        when :p
          Paragraph.new(element)
        when :blockquote
          BlockQuote.new(element)
        when :codeblock
          CodeBlock.new(element)
        when :header
          Header.new(element)
        when :li
          ListItem.new(element)
        when :ul
          UnorderedList.new(element)
        when :ol
          OrderedList.new(element)
        when :codespan
          CodeSpan.new(element)
        when :em
          Emphasis.new(element)
        when :img
          Image.new(element)
        when :br
          LineBreak.new(element)
        when :a
          Link.new(element)
        when :strong
          Strong.new(element)
        when :text
          Text.new(element)
        else
          raise UnsupportedElementError, "Element of type #{element.type} is not supported"
        end
      end
    end
  end
end
