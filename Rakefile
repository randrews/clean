require 'fileutils'

task :default => [:clean]

task :clean do
  files=Dir["**/*~"]
  puts "Removing #{files.size} Emacs temp file#{(files.size==1?'':'s')}"
  files.each do |tmp|
    FileUtils.rm tmp
  end

  puts "Removing generated files"
  `rm -f clean-*.gem clean-*.tar.gz`
end

task :package=>:build do
  file=Dir["*.gem"][0]
  if file=~ /.*?-([0-9.]+)\.gem/
    ver=$1
    `tar -czvf clean-#{ver}.tar.gz clean-#{ver}.gem`
  else
    raise "Gem is named weirdly: #{file}"
  end
end

task :build do
  `gem build clean.gemspec`
end
