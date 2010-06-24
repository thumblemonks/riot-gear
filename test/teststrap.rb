require 'rubygems'
require 'riot'
require 'webmock'
require 'pathname'

require 'riot/gear'

Dir[Pathname(__FILE__).dirname + "/riot_macros/**/*.rb"].each { |l| require l }
