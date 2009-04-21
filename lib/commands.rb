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
    puts(dry_run) unless $OPTS[:silent]
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
    "mv #{filename} #{directory}"
  end

  def real_run
    FileUtils.mv filename, directory
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
