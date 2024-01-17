# frozen_string_literal: true

require_relative "json_convertible"
require_relative "color"

module Trello2Notion
  # Notion RichText
  module Notion
    # Content for the RichText
    RichTextContent = Struct.new(:content, :link) do
      def to_h
        return { content:, link: } if link.nil?

        {
          content:,
          link: {
            url: link
          }
        }
      end
    end

    # Annotations to add formatting to RichText
    Annotations = Struct.new(:bold, :italic, :strikethrough, :underline, :code, :color)

    def default_annotations
      Annotations.new(false, false, false, false, false, COLOR[:default])
    end

    # A Notion rich text
    #
    # Since we come from markdown we don't cover href field (which references
    # other Notion things, and from Trello there are none) and we only support
    # the text content, since the other two (mention/equation) are Notion-specific.
    class RichText
      include JsonConvertible

      attr_reader :text, :annotations, :plain_text

      def initialize(text, annotations, plain_text)
        @type = "text"
        @text = text
        @annotations = annotations
        @plain_text = plain_text
      end

      def local_to_h
        {
          type: @type,
          text: @text.to_h,
          annotations: @annotations&.to_h,
          plain_text: @plain_text
        }
      end

      def self.basic(text)
        rich_text = RichTextContent.new(text, nil)
        RichText.new(rich_text, nil, text)
      end

      def self.empty
        basic("")
      end

      def self.link(content:, link:)
        rich_text = RichTextContent.new(content:, link:)
        RichText.new(rich_text, nil, content)
      end
    end
  end
end
