# frozen_string_literal: true

require_relative "../convertible"

module Trello2Notion
  module Markdown
    # A Markdown image
    class Image
      include Trello2Notion::Markdown::Convertible

      def initialize(element)
        @element = element
      end

      def convert(_parent = nil)
        external_file = Trello2Notion::Notion::ExternalFile.new(url: @element.attr["src"])
        Trello2Notion::Notion::Image.new(file: external_file)
      end
    end
  end
end
