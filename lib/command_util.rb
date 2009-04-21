##################################################
### Make commands ################################
##################################################

module CommandUtil
  def make_file_command filename
    dest=destination_for filename

    return nil unless dest

    if dest=="_rm"
      RemoveCommand.new filename
    else
      MoveCommand.new filename, dest
    end
  end

  def file_commands dir
    dir=File.expand_path dir
    cmds=Dir[File.join(dir, '*')].map do |filename|
      nil if File.directory? filename
      make_file_command(File.basename(filename))
    end

    cmds.compact.map { |c| c.path=dir ; c }
  end

  def dir_commands dir
    dir=File.expand_path dir

    cmds=config['directories'].keys.map do |dest|
      next if dest=='_rm'
      path=File.join(dir,dest)
      if File.exists?(path)
        if !File.directory?(path)
          Trollop::die "#{path} already exists, and isn't a directory"
        else
          nil
        end
      else
        CreateCommand.new dest,dir
      end
    end
    cmds.compact
  end
end
