# frozen_string_literal: true

require_relative "../convertible"

module Trello2Notion
  module Markdown
    # A Markdown paragraph
    class Paragraph
      include Convertible

      def initialize(element)
        @element = element
      end

      # Images are the only byproduct that is a separate block from the
      # span-level elements. They often appear as children to paragraphs, so
      # we have to extract them because there's no support for inline images
      # in Notion but there is for Markdown
      def convert(parent = nil)
        images =
          image_children.map { |i| Convertible.from_elem(i).convert(parent) }

        # FIXME: Why flatten here? There's a mistake somewhere
        rich_text =
          @element
          .children
          .difference(image_children)
          .map { |e| more_images(images, Convertible.from_elem(e).convert) }.flatten

        # Return a paragraph if it's a stand alone paragraph at the top level,
        # otherwise return the rich text
        return [images] << Trello2Notion::Notion::Paragraph.new(rich_text:) if parent.nil?

        [images, rich_text]
      end

      private

      # FIXME: This looks weird. Refactor.
      def more_images(images, rich_text)
        case rich_text
        in [image, text]
          images << image
          text
        else
          rich_text
        end
      end

      def image_children
        @element.children.filter { |e| e.type == :img }
      end
    end
  end
end
