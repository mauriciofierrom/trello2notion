# frozen_string_literal: true

require "functions_framework"

require_relative "lib/trello2notion/trello/json_export"
require_relative "lib/trello2notion/trello/decorators"
require_relative "lib/trello2notion/trello/notion/client"
require_relative "lib/trello2notion/trello/notion/parent"

FunctionsFramework.http "trello2notion" do |request|
  case request["action"]
  when :markdown
    # process and upload resulting file to a google cloud bucket
end
