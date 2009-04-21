##################################################
### Options ######################################
##################################################

module Options
  def get_options args=ARGV
    opts=Trollop::options(args) do
      version "cleaner 1.0.0"
      banner <<-EOS
Cleaner is a program for automatically sorting files based on their extensions.

Usage:
       clean [options] <dirs>+

where [options] are:
EOS
      opt(:dry_run, "Just print commands, don't move anything",
          :default=>false)
      opt(:config_file, "Where to load mappings from",
          :default=>'~/.clean.yml', :type=>String)
      opt(:silent, "Don't print commands",
          :default=>false)
      opt(:on_collision, "If the destination file already exists, rename, overwrite, or ignore?",
          :default=>'rename')
    end

    Trollop::die "Must specify at least one directory to clean" if args.empty?

    opts[:dirs]=args
    opts
  end
end
