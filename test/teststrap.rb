require 'pathname'

$:.unshift (Pathname(__FILE__).dirname + ".." + "lib").to_s

require 'rubygems'
require 'riot'
require 'webmock'

require 'riot/gear'

Dir[(Pathname(__FILE__).dirname + "/riot_macros/**/*.rb").to_s].each { |l| require l }
