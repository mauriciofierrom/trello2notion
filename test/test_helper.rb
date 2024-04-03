# frozen_string_literal: true
#
require "simplecov"
SimpleCov.start

require "simplecov-cobertura"
require "simplecov-console"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::CoberturaFormatter,
  SimpleCov::Formatter::Console
])

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "trello2notion"

require "minitest/reporters"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require "minitest/autorun"
