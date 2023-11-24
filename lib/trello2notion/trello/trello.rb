# frozen_string_literal: true

module Trello2Notion
  module Trello
    # A struct representation for a member of a Trello board
    BoardMember = Struct.new(:id, :name)
    # A struct representation for a card comment
    Comment = Struct.new(:text, :creator, :date)
    # A struct representation card in a Trello board
    Card = Struct.new(:id, :name, :description, :last_activity, :comments)
    # A struct representation for a Trello board
    Board = Struct.new(:name, :cards)
  end
end
