# frozen_string_literal: true

require "json"

module Trello2Notion
  module Trello
    # Module used to parse Trello's JSON export
    module JSONExport
      KEYS = {
        actions: "actions",
        card: "card",
        cards: "cards",
        member_creator: "idMemberCreator",
        members: "members",
        data: "data",
        text: "text",
        date: "date",
        id: "id",
        name: "name",
        description: "desc",
        last_activity: "dateLastActivity",
        full_name: "fullName",
        type: "type",
        comment_card: "commentCard"
      }.freeze

      def self.parse(board_json)
        members = parse_members(board_json)
        cards = parse_cards(board_json, members)

        Board.new(board_json[KEYS[:name]], cards)
      end

      def self.load_file(filepath)
        board_json = JSON.load_file(filepath)
        parse(board_json)
      end

      def self.parse_members(json)
        return [] if json[KEYS[:members]].nil?

        json[KEYS[:members]].map do |j|
          BoardMember.new(j[KEYS[:id]], j[KEYS[:full_name]])
        end
      end

      def self.parse_comment(action_json, members = [])
        member_id = action_json[KEYS[:member_creator]]
        creator = members.find { |e| e.id == member_id }

        Comment.new(action_json[KEYS[:data]][KEYS[:text]],
                    creator,
                    DateTime.parse(action_json[KEYS[:date]]))
      end

      # rubocop:disable Metrics/AbcSize
      def self.parse_comments(card, members, actions_json)
        actions_json
          .filter do |j|
            j[KEYS[:type]] == KEYS[:comment_card] &&
              j[KEYS[:data]][KEYS[:card]][KEYS[:id]] == card.id
          end
          .sort do |a, b|
            DateTime.parse(b[KEYS[:date]]) <=> DateTime.parse(a[KEYS[:date]])
          end
          .map { |action_json| parse_comment(action_json, members) }
      end
      # rubocop:enable Metrics/AbcSize

      def self.parse_card(card_json)
        Card.new(card_json[KEYS[:id]],
                 card_json[KEYS[:name]],
                 card_json[KEYS[:description]],
                 DateTime.parse(card_json[KEYS[:last_activity]]),
                 [])
      end

      def self.parse_cards(board_json, members = [])
        cards = []

        board_json["cards"].each do |card_json|
          card = parse_card(card_json)
          comments = parse_comments(card, members, board_json[KEYS[:actions]])
          card.comments = comments
          cards << card
        end

        cards
      end
    end
  end
end
