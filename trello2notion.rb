#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "json"

require_relative "lib/trello2notion/trello/json_export"
require_relative "lib/trello2notion/trello/decorators"
require_relative "lib/trello2notion/trello/notion/client"
require_relative "lib/trello2notion/trello/notion/parent"

include Trello2Notion::Trello

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: trello2notion [options]"

  opts.on("-m", "--markdown", "Generate markdown") do
    options[:action] = :markdown
  end

  opts.on("-n", "--notion", "Generate Notion") do
    options[:action] = :notion
  end

  opts.on("-f", "--file MANDATORY", "Input file") do |f|
    options[:file] = f
  end

  opts.on("-o", "--output FILENAME", "Output file") do |f|
    options[:output_file] = f
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

raise "No input file specified. Call trello2notion with the -f / --file flag" unless options[:file]
input_file = File.read(options[:file])
parsed_board = JSONExport.parse(JSON.parse(input_file))

case options[:action]
when :markdown
  markdown = MarkdownDecorator.new(parsed_board).generate
  if options[:output_file]
    File.write(options[:output_file], markdown)
  else
    pp markdown
  end
when :notion
  notion_client = Trello2Notion::Trello::Notion::Client.new(ENV["NOTION_API_KEY"])

  base_page, subpages_builder = NotionDecorator.new(parsed_board).generate
  base_page.parent = Trello2Notion::Notion::PageParent.new(page_id: "3c814723-fbe4-4ca8-b79c-439fed8ad1b7")
  page_id = notion_client.create_page(base_page.to_json)
  subpages_builder.call(page_id:).each do |subpage|
    notion_client.create_page(subpage.to_json)
  rescue e
    pp subpage
  end
else
  puts "No action provided"
end
