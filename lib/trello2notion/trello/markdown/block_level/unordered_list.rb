# frozen_string_literal: true

require_relative "../convertible"
require "pry"

module Trello2Notion
  module Markdown
    # A Markdown unordered list
    class UnorderedList
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert(_parent = nil)
        # TODO: Extract the extra blocks here
        extras = []
        results = []

        @element.children.map do |e|
          extra, result = Convertible.from_elem(e).convert(self)
          extras += extra
          results += result
        end

        [extras, results]
      end
    end
  end
end
