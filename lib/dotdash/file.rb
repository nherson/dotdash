#
# Module to handle all requests
# that begin with 'dotdash file ...'
#

require 'dotdash'

module DotdashFile

  OPS_LIST = [ "clone",
               "edit", 
               "delete", 
               "import",
               "mkdir",
             ]

  def clone_file(src_host, file, dest_host=self.host)
    check_if_host_exists src_host
    check_if_host_exists dest_host
    check_if_file_exists src_host, file
    check_if_file_taken dest_host, file
    dest_dir = [self.dir, dest_host, File.dirname(file)].join '/'
    src_path = [self.dir, src_host, file].join '/'
    FileUtils.mkdir_p dest_dir
    FileUtils.cp_r src_path, dest_dir
  end

  def edit_file(file, host=self.host)
    check_if_host_exists host
    check_if_file_exists host, file
    path = [ self.dir, host, file ].join '/'
    Kernel.send(:`, "#{self.editor} #{path}")
  end

  def delete_file(file, host=self.host)
    # TODO: add a confirmation prompt when deleting a directory
    check_if_host_exists host
    check_if_file_exists host, file
    file_path = [ self.dir, host, file ].join '/'
    FileUtils.rm_rf file_path
  end

  def import_file(file, host=self.host)
    check_if_host_exists host
    if not file[0] == '/'
      rel_path = file
      file_path = [File.expand_path("~"), file].join '/'
    else
      rel_path = File.basename(file)
      file_path = file
    end
    if not File.exists?(file_path)
      DotdashError.system_file_not_found file_path
    end
    dest_path = [self.dir, host].join '/'
    check_if_file_taken host, file
    FileUtils.cp_r file_path, dest_path
  end

  def dispatch_file(args)
    # TODO Add proper error handling here
    # preferably a usage statement
    if args.empty?
      puts "empty args"
      exit 1
    elsif OPS_LIST.include? args[0]
      self.send(args[0], *args[1..-1])
    else
      # Again, error handling
      puts "Don't know what to do with #{args[0]}"
      exit 1
    end
  end

  # Helper methods
  
  # path can be either a file or a directory
  def check_if_file_exists(host, file)
    file_path = [ self.dir, host, file ].join '/'
    if not File.exists? file_path
      DotdashError.file_not_found(host, file)
    end
  end

  def check_if_file_taken(host, file)
    file_path = [ self.dir, host, file ].join '/'
    if File.exists? file_path
      DotdashError.file_already_exists host, file
    end
  end

end
