##################################################
### Read config file #############################
##################################################

module Config
  def config
    return @config if @config

    file=File.expand_path($OPTS[:config_file])
    if File.exists? file
      @config||=YAML.load(File.open(file))
    else
      ex=File.expand_path(File.join(File.dirname(__FILE__),
                                    '..','res','clean.yml'))
      puts "Warning: config file #{file} not found; using default #{ex}"
      @config||=YAML.load(File.open(ex))
    end
  end

  def destination_map
    unless @destination_map
      @destination_map={}
      config['directories'].each do |directory, extensions|
        extensions.each do |ext|
          @destination_map[ext]=directory
        end
      end
    end
    @destination_map
  end
end
