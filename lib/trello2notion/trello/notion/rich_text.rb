# frozen_string_literal: true

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
      attr_reader :type, :text, :annotations, :plain_text

      def initialize(text, annotations, plain_text)
        @type = "text"
        @text = text
        @annotations = annotations
        @plain_text = plain_text
      end

      def to_h
        {
          type: @type,
          text: @text.to_h,
          annotations: @annotations&.to_h,
          plain_text: @plain_text
        }
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end
