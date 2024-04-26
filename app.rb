# frozen_string_literal: true

require "functions_framework"

require_relative "lib/trello2notion/trello/json_export"
require_relative "lib/trello2notion/trello/decorators"
require_relative "lib/trello2notion/trello/notion/client"
require_relative "lib/trello2notion/trello/notion/parent"


FunctionsFramework.cloud_event "trello2notion" do |cloud_event|
  # code here
end
