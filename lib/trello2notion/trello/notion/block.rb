# frozen_string_literal: true

require "json"

module Trello2Notion
  module Notion
    # Base class for notion blocks
    class Block
      attr_accessor :object, :type

      def initialize(object: :object, **rest)
        @object = object
        @type = type_from_class(self)

        post_init(**rest) if rest
      end

      def to_json(*)
        to_h.to_json(*)
      end

      def to_h
        local_to_h(
          {
            object: @object,
            type: @type
          }
        )
      end

      def post_init(**_args)
        nil
      end

      def local_to_h(hash)
        raise NotImplementedError, "Class #{self.class} must implement local_to_h"
      end

      private

      # WARN: This seems to be a big mistake
      def type_from_class(obj)
        obj
          .class
          .name
          .split("::")
          .last
          .scan(/([A-Z][a-z]*|\d+)/)
          .join("_")
          .downcase
      end

      def default_object
        :object
      end
    end
  end
end
