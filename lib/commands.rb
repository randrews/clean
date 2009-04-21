class Command
  attr_accessor :path

  def priority ; nil ; end

  def transform filename
    if path
      File.join path, filename
    else
      File.join '.', filename
    end
  end

  def run
    unless $OPTS[:silent]
      dr=dry_run
      puts(dry_run) if dry_run
    end

    real_run unless $OPTS[:dry_run]
  end

  def dry_run ; raise NotImplementedError ; end
  def real_run ; raise NotImplementedError ; end

  def <=> other
    priority <=> other.priority
  end
end

##################################################
### Move files ###################################
##################################################

class MoveCommand < Command
  def priority ; 2 ; end

  def initialize *args
    (@filename, @directory, @path)=args
  end

  def filename ; transform @filename ; end
  def directory ; transform @directory ; end

  def dry_run
    case $OPTS[:on_collision]
    when 'overwrite'
      "mv #{filename} #{directory}"
    when 'rename'
      "mv #{filename} #{File.join(directory,unique_name)}"
    else # 'ignore' also
      # emit nothing
    end
  end

  def real_run
    case $OPTS[:on_collision]
    when 'overwrite'
      mv
    when 'rename'
      if collision?
        FileUtils.mv filename, File.join(directory,unique_name)
      else
        mv
      end
    else # captures the 'ignore' option too
      # do nothing
    end
  end

  private

  def mv
    FileUtils.mv filename, directory
  end

  def collision? fname=filename
    File.exists?(File.join(directory,File.basename(fname)))
  end

  def unique_name
    fname=filename

    # make sure there's a real collision
    return fname unless collision? fname

    # ext is like ".jpg"
    ext=File.extname(fname)

    # Base is the filename - dir and extension, so /foo/bar.txt -> bar
    base=File.basename(fname,ext)

    # loop until we find an n that'll work. Start with bar-1.txt
    n=1
    n+=1 while collision?("#{base}-#{n}#{ext}")

    "#{base}-#{n}#{ext}"
  end
end

##################################################
### Create directories ###########################
##################################################

class CreateCommand < Command
  def priority ; 1 ; end

  def initialize *args
    (@dirname, @path)=args
  end

  def dirname ; transform @dirname ; end

  def dry_run
    "mkdir #{dirname}"
  end

  def real_run
    FileUtils.mkdir_p dirname
  end
end

##################################################
### Remove files #################################
##################################################

class RemoveCommand < Command
  def priority ; 3 ; end

  def initialize *args
    (@filename, @path)=args
  end

  def filename ; transform @filename ; end

  def dry_run
    "rm #{filename}"
  end

  def real_run
    FileUtils.rm filename
  end
end
