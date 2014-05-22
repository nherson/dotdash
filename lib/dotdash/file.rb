#
# Module to handle all requests
# that begin with 'dotdash file ...'
#

require 'dotdash'

module DotdashFile

  OPS_LIST = [ "clone", "edit", "delete", "import" ]

  def DotdashFile.clone
    puts "you ran 'dotdash file clone'"
  end

  def DotdashFile.edit
    puts "you ran 'dotdash file edit'"
  end

  def DotdashFile.delete
    puts "you ran 'dotdash file delete'"
  end

  def DotdashFile.import
    puts "you ran 'dotdash file import'"
  end

  def DotdashFile.dispatch(args)
    # TODO Add proper error handling here
    # preferably a usage statement
    if args.empty?
      puts "empty args"
      exit 1
    elsif OPS_LIST.include? args[0]
      DotdashFile.send(args[0], *args[1..-1])
    else
      # Again, error handling
      puts "Don't know what to do with #{args[0]}"
      exit 1
    end
  end

  def DotdashFile.method_missing(method, *args, &block)
    DotdashError.unknown_subcommand(method, OPS_LIST)
  end

end
