# frozen_string_literal: true

require "uri"

module Trello2Notion
  module Notion
    class UnsupportedImageTypeError < StandardError; end

    SUPPORTED_IMAGE_TYPES = %w[
      .bmp
      .gif
      .heic
      .jpeg
      .jpg
      .png
      .svg
      .tif
      .tiff
    ].freeze

    # A Notion image block
    class Image < Block
      attr_accessor :file

      def post_init(file:)
        @file = validate_url(file)
      end

      def local_to_h(hash)
        hash.merge(
          {
            image: @file
          }
        )
      end

      private

      def validate_url(file)
        uri = URI.parse(file.url)
        extension = File.extname(uri.path)

        unless SUPPORTED_IMAGE_TYPES.include? extension
          raise UnsupportedImageTypeError, "Unsupported image type: #{extension}"
        end

        file
      end
    end
  end
end
