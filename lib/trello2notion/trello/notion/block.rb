# frozen_string_literal: true

require "json"

require_relative "json_convertible"

module Trello2Notion
  module Notion
    # Base class for notion blocks
    class Block
      include JsonConvertible

      attr_accessor :object, :type

      def initialize(object: :object, **rest)
        @object = object
        @type = type_from_class(self)

        post_init(**rest) if rest
      end

      def local_to_h
        {
          object: "block",
          type: @type
        }.merge block_to_h
      end

      def block_to_h
        raise NotImplementedError, "Class #{self.class} must implement block_to_h"
      end

      def post_init(**_args)
        nil
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
