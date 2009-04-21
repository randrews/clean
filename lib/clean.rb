require 'rubygems'
require 'yaml'
require 'activesupport'
require 'fileutils'
require 'trollop'

Dir[File.join(File.dirname(__FILE__),'*.rb')].each do |file|
  require file
end
