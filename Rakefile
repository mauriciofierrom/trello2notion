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

task :package_functions do
  # Array of the functions to pack
  functions = %w[budget-alert rate-limiter]

  # Array of directories to exclude. If any of the paths include these dirs the path is excluded
  # from the zip file.
  exclude = %w[node_modules]

  functions.each do |function|
    directory_to_zip = "support/#{function}/"
    zip_file_name = "terraform/#{function}-function.zip"
    files_to_include =
      Dir[File.join(directory_to_zip, "**", "*")].reject { |f| exclude.any? { |e| f.include?(e) } }

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

task terraform: :package_function do
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
