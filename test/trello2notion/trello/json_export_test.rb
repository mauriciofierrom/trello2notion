# frozen_string_literal: true

require "json"
require "date"
require "test_helper"
require "trello2notion/trello/trello"
require "trello2notion/trello/json_export"

class JSONExportTest < Minitest::Test
  include Trello2Notion::Trello

  def test_parse_board
    member1 = BoardMember.new("1,2,3", "Member 1")
    member2 = BoardMember.new("3,2,1", "Member 2")

    comment1 = Comment.new("Some text", member1, DateTime.parse("2018-05-21T10:46:48.694Z"))
    comment2 = Comment.new("Some other text", member2, DateTime.parse("2018-05-21T10:43:30.236Z"))

    card1 = Card.new("123",
                     "Test card #1",
                     "This is the description of this card",
                     DateTime.parse("2018-06-26T20:15:48.225Z"),
                     [comment1])
    card2 = Card.new("321",
                     "Test card #2",
                     "This is the description of the other card",
                     DateTime.parse("2018-05-21T10:45:38.564Z"),
                     [comment2])

    expected_board = Board.new("Test board", [card1, card2])

    json = <<~JSON
      {
        "name": "Test board",
        "cards": [
          {
            "id": "123",
            "name": "Test card #1",
            "dateLastActivity": "2018-06-26T20:15:48.225Z",
            "desc": "This is the description of this card"
          },
          {
            "id": "321",
            "name": "Test card #2",
            "dateLastActivity": "2018-05-21T10:45:38.564Z",
            "desc": "This is the description of the other card"
          }
        ],
        "members": [
          {
            "id": "1,2,3",
            "fullName": "Member 1"
          },
          {
            "id": "3,2,1",
            "fullName": "Member 2"
          }
        ],
        "actions": [
          {
            "idMemberCreator": "1,2,3",
            "type": "commentCard",
            "date": "2018-05-21T10:46:48.694Z",
            "data": {
              "text": "Some text",
              "card": {
                "id": "123"
              }
            }
          },
          {
            "idMemberCreator": "3,2,1",
            "type": "commentCard",
            "date": "2018-05-21T10:43:30.236Z",
            "data": {
              "text": "Some other text",
              "card": {
                "id": "321"
              }
            }
          }
        ]
      }
    JSON

    assert_equal expected_board, JSONExport.parse(JSON.parse(json))
  end
end
