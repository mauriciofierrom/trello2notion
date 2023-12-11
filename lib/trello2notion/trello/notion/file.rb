# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A Notion file. API currently doesn't support uploading files to Notion
    class NotionFile
      attr_accessor :url, :expiry_time

      def initialize(url:, expiry_time:)
        @url = url
        @expiry_time = DateTime.iso8601(expiry_time)
      end

      def to_h
        {
          type: :file,
          file: {
            url: @url,
            expiry_time: "#{@expiry_time.strftime("%FT%T.%L")}Z"
          }
        }
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end

    # An Notion external file (not hosted by Notion)
    class ExternalFile
      attr_accessor :url

      def initialize(url:)
        @url = url
      end

      def to_h
        {
          type: :external,
          external: {
            url: @url
          }
        }
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end
