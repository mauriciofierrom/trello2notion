# frozen_string_literal: true

module Trello2Notion
  module Notion
    # Module for ducks that are convertible to json and have a type value
    module JsonConvertible
      def to_h
        {}.merge(local_to_h)
      end

      def local_to_h
        raise NotImplementedError, "Class #{self.class} must implement local_to_h"
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end
