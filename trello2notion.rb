#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "json"

require_relative "lib/trello2notion/trello/json_export"
require_relative "lib/trello2notion/trello/decorators"

include Trello2Notion::Trello

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: trello2notion [options]"

  opts.on("-m", "--markdown", "Generate markdown") do
    options[:action] = :markdown
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

case options[:action]
when :markdown
  if options[:file]
    input_file = File.read(options[:file])
    parsed_board = JSONExport.parse(JSON.parse(input_file))
    markdown = MarkdownDecorator.new(parsed_board).generate
    if options[:output_file]
      File.write(options[:output_file], markdown)
    else
      pp markdown
    end
  else
    raise "No input file specified. Call trello2notion with the -f / --file flag"
  end
else
  puts "No action provided"
end
