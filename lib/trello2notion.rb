# frozen_string_literal: true

require_relative "trello2notion/version"
require_relative "trello2notion/trello/notion"
require_relative "trello2notion/trello/markdown"
require_relative "trello2notion/trello/trello"
require_relative "trello2notion/trello/debug"

module Trello2notion
  class Error < StandardError; end
  # Your code goes here...
end
