# frozen_string_literal: true

require_relative "../convertible"

module Trello2Notion
  module Markdown
    # A Markdown image
    class Image
      include Convertible

      def initialize(element)
        @element = element
      end

      def convert
        external_file = Trello2Notion::Notion::ExternalFile.new(url: @element.attr["src"])
        Trello2Notion::Notion::Image.new(file: external_file)
      end
    end
  end
end
