# frozen_string_literal: true

require "kramdown"

require_relative "json_export_decorator"
require_relative "../markdown/convertible"
require_relative "../notion"
require_relative "../markdown"

module Trello2Notion
  module Trello
    # Decorator to generate a Notion Page creation request from a board
    class NotionDecorator < Trello2Notion::Trello::JSONExportDecorator
      include Trello2Notion::Notion
      include Trello2Notion::Markdown

      def generate
        [board_to_page, method(:sub_pages)]
      end

      private

      def board_to_page
        Page.new(title: @board.name, parent: WorkspaceParent.new)
      end

      def card_to_page(card, board_page)
        page = Page.new(title: card.name, parent: board_page)
        root = Kramdown::Parser::Markdown.parse(card.description)
        conversions = root[0].children.map { |e| Convertible.from_elem(e).convert }
        combined = combine_children(conversions)
        page.children.push(*combined)
        page
      end

      # TODO: Less effects, more functional goodness
      def comments_to_page(card)
        card.comments.map do |comment|
          root = Kramdown::Parser::Markdown.parse(comment.text)
          conversions = root[0].children.map { |e| Convertible.from_elem(e).convert }
          combine_children(conversions.first).reverse
        end.flatten
      end

      # rubocop:disable Metrics/MethodLength
      def combine_children(conversions)
        conversions.reduce([]) do |list, element|
          case element
          in [extra, converted]
            list << extra unless extra.empty?
            list << converted
          in [converted]
            list << converted
          in []
            list
          in _
            list << element
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      def sub_pages(page_id:)
        page_parent = PageParent.new(page_id:)
        @board.cards.map do |card|
          card_page = card_to_page(card, page_parent)
          card_page.children.push(*comments_to_page(card))
          card_page
        end
      end
    end
  end
end
