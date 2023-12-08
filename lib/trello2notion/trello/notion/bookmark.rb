# frozen_string_literal: true

require_relative "block"

module Trello2Notion
  module Notion
    # A Notion bookmark block
    class Bookmark < Block
      attr_accessor :caption, :url

      def post_init(caption: [], url: nil)
        @caption = caption
        @url = url
      end

      def local_to_h(hash)
        hash.merge(
          {
            bookmark: {
              caption: @caption,
              url: @url
            }
          }
        )
      end
    end
  end
end
