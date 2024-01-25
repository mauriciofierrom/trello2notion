# frozen_string_literal: true

require_relative "../convertible"
require_relative "../../notion"

module Trello2Notion
  module Markdown
    # A Markdown list item
    class ListItem
      include Convertible
      include Trello2Notion::Notion

      class IncorrectListItemParentError < StandardError; end

      def initialize(element)
        @element = element
      end

      # rubocop:disable Metrics/MethodLength
      def convert(parent = nil)
        extra_blocks, result = convert_children

        children = result.filter { |r| r.instance_of?(BulletedListItem) || r.instance_of?(NumberedListItem) }
        rich_text = result.difference(children).flatten

        case parent.element.type
        when :ul
          [extra_blocks, [BulletedListItem.new(rich_text:, children:)]]
        when :ol
          [extra_blocks, [NumberedListItem.new(rich_text:, children:)]]
        else
          raise IncorrectListItemParentError, "List item must belong to ul or ol only not to #{parent.element.type}"
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
