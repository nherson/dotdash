#
# Module to handle all requests
# that begin with 'dotdash file ...'
#

require 'dotdash'

module DotdashFile
  #include DotdashBase

  OPS_LIST = [ "clone", "edit", "delete", "import" ]

  def DotdashFile.clone
    puts "you ran 'dotdash file'"
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

  def dispatch(args)
    if args.empty?
      puts "empty args"
      exit 1
    elsif OPS_LIST.include? args[0]
      self.send(args[0])
    else
      puts "Don't know what to do with #{args[0]}"
    end
  end

end
