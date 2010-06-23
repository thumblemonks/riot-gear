require 'rubygems'
require 'rake'

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
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
