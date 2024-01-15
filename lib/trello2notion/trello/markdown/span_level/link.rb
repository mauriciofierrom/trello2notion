# frozen_string_literal: true

require_relative "../convertible"
require_relative "../../notion/rich_text"

module Trello2Notion
  module Markdown
    # A Markdown link
    class Link
      include Convertible
      include Trello2Notion::Notion

      class UnsupportedLinkError < StandardError; end

      def initialize(element)
        @element = element
      end

      def convert
        child = @element.children[0]

        case child.type
        when :text
          [RichText.link(content: child.value, link: @element.attr["href"])]
        when :img
          build_image_parts
        else
          raise UnsupportedLinkError, "The contents of the link is not supported: #{child.type}"
        end
      end

      private

      def build_image_parts
        child = @element.children[0]
        content = child.attr["alt"] || child.attr["title"] || "Image link"
        link = @element.attr["href"]

        # TODO: Add image and convertion here: Image.new(child).convert
        [Image.new(child).convert, RichText.link(content:, link:)]
      end
    end
  end
end
