Gem::Specification.new do |s|
  s.name='clean'
  s.version='1.1.1'
  s.date='2009-03-08'
  s.author='Andrews, Ross'
  s.email='randrews@geekfu.org'
  s.homepage='http://geekfu.org'
  s.platform=Gem::Platform::RUBY
  s.summary="A utility for sorting messy folders"

  s.files = [ "res/clean.yml",
              "lib/clean.rb",
              "lib/command_util.rb",
              "lib/commands.rb",
              "lib/config.rb",
              "lib/destinations.rb",
              "lib/options.rb"]

  s.executables=["clean"]
  s.has_rdoc=false
  s.add_dependency("activesupport",">= 2.1.0")
  s.add_dependency("trollop",">= 1.10.2")
end
