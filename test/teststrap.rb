require 'pathname'

$:.unshift(Pathname(__FILE__).dirname + ".." + "lib")

require 'rubygems'
require 'riot'
require 'webmock'

require 'riot/gear'

Dir[Pathname(__FILE__).dirname + "/riot_macros/**/*.rb"].each { |l| require l }
