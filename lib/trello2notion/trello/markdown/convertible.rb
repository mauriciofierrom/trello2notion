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

      def convert(parent = nil)
        raise NotImplementedError, "Class #{self.class} must implement method #convert"
      end

      # This can only return an image as an extra block, and rich text (for
      # now).
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def convert_children
        stack = @element.children.map { |e| [e, self] }.reverse
        result = []
        extra_blocks = []

        until stack.empty?
          e, p = stack.pop
          extra, res = Convertible.from_elem(e).convert(p)

          result.concat(res)

          extra_blocks.concat(extra)

          block_children = e.children.filter(&:block?)
          o = p.element.type == :li ? block_children.filter { |l| %i[ul ol].include? l.type } : block_children
          o.each { |b| stack.push([b, Convertible.from_elem(e)]) }
        end

        # FIXME: Why flatten here? There's a mistake somwhere
        [extra_blocks.flatten, result]
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      def self.from_elem(element)
        case element.type
        when :p
          Paragraph.new(element)
        when :blank
          Blank.new(element)
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
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    end
  end
end
