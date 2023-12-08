# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A Notion divider block
    class Divider < Block
      def local_to_h(hash)
        hash.merge(
          {
            divider: {}
          }
        )
      end
    end
  end
end
