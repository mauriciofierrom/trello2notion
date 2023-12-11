# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A Notion code block
    class Code < Block
      attr_accessor :caption, :rich_text, :language

      def post_init(caption: [], rich_text: [], language: LANGUAGE[:plain_text])
        @caption = caption
        @rich_text = rich_text
        @language = language
      end

      def block_to_h
        {
          code: {
            caption: @caption,
            rich_text: @rich_text,
            language: @language
          }
        }
      end
    end
  end
end
