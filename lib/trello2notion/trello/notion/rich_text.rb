# frozen_string_literal: true

require_relative "json_convertible"

module Trello2Notion
  module Notion
    # Content for the RichText
    RichTextContent = Struct.new(:content, :url)

    # Annotations to add formatting to RichText
    Annotations = Struct.new(:bold, :italic, :strikethrough, :underline, :code, :color)

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
    end
  end
end
