require 'rubygems'

require 'rake'
require 'rake/testtask'

#
# Other rake tasks

Dir[File.dirname(__FILE__) + "/lib/tasks/*.rake"].each { |rake_task| load rake_task }

#
# Console!

task(:console) { exec "irb -r boot" }

#
# Testing

Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end
Rake::Task["test"].instance_variable_set(:@full_comment, nil) # Dumb dumb dumb
Rake::Task["test"].comment = "Run the tests!"

task :default => :test

#
# Some monks like diamonds. I like gems.

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "riot-gear"
    gem.summary = "Riot + HTTParty smoke testing framework"
    gem.description = "Riot + HTTParty smoke testing framework. You'd use it for integration testing with real HTTP requests and responses"
    gem.email = "gus@gusg.us"
    gem.homepage = "http://github.com/thumblemonks/riot-gear"
    gem.authors = ["Justin 'Gus' Knowlden"]
    gem.add_dependency 'riot'
    gem.add_dependency 'httparty'
    gem.add_development_dependency 'webmock'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
