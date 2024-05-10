# frozen_string_literal: true

require "zip"

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task :package_function do
  directory_to_zip = "support/budget-alert/"
  zip_file_name = "terraform/budget-alert-function.zip"
  files_to_include = Dir[File.join(directory_to_zip, "**", "*")].reject { |f| f.include?("node_modules") }

  FileUtils.rm_f(zip_file_name)

  Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
    files_to_include.each do |file|
      zipfile.add(file.sub(directory_to_zip, ""), file)
    end
  end

  puts "Directory has been zipped to #{zip_file_name}"
end

task default: %i[test rubocop]
