# frozen_string_literal: true

require_relative "../convertible"

module Trello2Notion
  module Markdown
    # A Markdown ordered list
    class OrderedList
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert(_parent = nil)
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
