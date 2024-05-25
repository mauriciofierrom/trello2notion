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

# rubocop:disable Metrics/BlockLength
task :package_functions do
  # Functions to pack
  functions = [
    {
      name: "budget-alert",
      dir: "support/budget-alert",
      exclude: %w[node_modules]
    },
    {
      name: "rate-limiter",
      dir: "support/rate-limiter",
      exclude: %w[node_modules]
    },
    {
      name: "conversor",
      dir: ".",
      exclude: %w[support terraform]
    }
  ]

  functions.each do |function|
    directory_to_zip = "#{function[:dir]}/"
    zip_file_name = "terraform/#{function[:name]}-function.zip"
    files_to_include =
      Dir[File.join(directory_to_zip, "**", "*")].reject { |f| function[:exclude].any? { |e| f.include?(e) } }

    FileUtils.rm_f(zip_file_name)

    Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
      files_to_include.each do |file|
        zipfile.add(file.sub(directory_to_zip, ""), file)
      end
    end

    puts "Directory has been zipped to #{zip_file_name}"
  end

  puts "Finished packaging functions"
end
# rubocop:enable Metrics/BlockLength

task terraform: :package_functions do
  Dir.chdir("terraform") do
    sh "terraform init"
    sh "terraform plan -var-file=secrets.tfvars -out=tfplan"
    sh "terraform apply -auto-approve tfplan"
  end
end

task :terraform_destroy do
  Dir.chdir("terraform") do
    sh "terraform destroy -var-file=secrets.tfvars"
  end
end

task default: %i[test rubocop]
