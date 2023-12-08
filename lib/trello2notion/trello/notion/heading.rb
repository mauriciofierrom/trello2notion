# frozen_string_literal: true

require_relative "block"

module Trello2Notion
  module Notion
    # A Notion Heading block base class
    class Heading < Block
      attr_reader :rich_text, :color, :toggleable

      def post_init(rich_text:, color: COLOR[:default], toggleable: false)
        @rich_text = rich_text || []
        @color = color
        @toggleable = toggleable
      end

      def local_to_h(hash)
        hash.merge(
          {
            @type => {
              rich_text: @rich_text,
              color: @color,
              is_toggleable: @toggeable.nil? ? false : @toggleable
            }
          }
        )
      end
    end

    class Heading1 < Heading; end
    class Heading2 < Heading; end
    class Heading3 < Heading; end
  end
end
