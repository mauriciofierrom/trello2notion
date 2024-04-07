# frozen_string_literal: true

require "faraday"

module Trello2Notion
  module Trello
    module Notion
      # Client for the Notion API
      class Client
        def initialize(access_token)
          pp access_token
          @conn = Faraday.new(url: "https://api.notion.com/v1/") do |builder|
            builder.request :authorization, "Bearer", access_token
            builder.request :json
            builder.response :json
            builder.response :raise_error
            builder.headers["Notion-Version"] = "2022-06-28"
          end
        end

        # Performs a creation request for a page and returns the id of the created page
        def create_page(page)
          response = @conn.post("pages", page)
          response.body["id"]
        rescue Faraday::Error => e
          puts e.response[:status]
          puts e.response[:body]
        end
      end
    end
  end
end
