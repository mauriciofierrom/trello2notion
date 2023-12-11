# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A Notion divider block
    class Divider < Block
      def block_to_h
        {
          divider: {}
        }
      end
    end
  end
end
