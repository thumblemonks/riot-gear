require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake/testtask'

#
# Other rake tasks

Dir[File.dirname(__FILE__) + "/lib/tasks/*.rake"].each { |rake_task| load rake_task }

#
# Console!

task(:console) { exec "irb -r boot" }

#
# Testing
task :default => ["test"]

Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  #t.warning = true
  t.verbose = false
end

task :default => :test

