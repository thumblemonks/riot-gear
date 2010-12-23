require 'pathname'

$:.unshift((Pathname(__FILE__).dirname + ".." + "lib").to_s)

require 'rubygems'
require 'json'
require 'riot'
require 'webmock'

Riot::Situation.instance_eval { include WebMock::API }

require 'riot/gear'

Dir[(Pathname(__FILE__).dirname + "/riot_macros/**/*.rb").to_s].each { |l| require l }
