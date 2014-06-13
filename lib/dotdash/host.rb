# 
# Responsible for all work at the host level
#
module DotdashHost

  HOST_CMDS = ['create',
              'clone',
              'delete',
              'rename',
              'list',
             ]

  USAGE = "dotdash host {create|rename|delete|clone|list} HOST1 [HOST2]"

  def create_host(host)
    check_if_host_taken host
    # make the host (create the directory)
    Dir.mkdir(@dir + "/#{host}")
  end

  def clone_host(orig_host, new_host)
    check_if_host_taken new_host 
    check_if_host_exists orig_host
    FileUtils.cp_r(@dir + "/#{orig_host}", @dir + "/#{new_host}")
  end

  def delete_host(host)
    # TODO add a confirmation prompt here
    check_if_host_exists host
    FileUtils.rm_rf @dir + "/#{host}"
  end

  def rename_host(old_host, new_host)
    # TODO add a confirmation prompt here
    check_if_host_exists old_host
    check_if_host_taken new_host
    FileUtils.mv(@dir + "/#{old_host}", @dir + "/#{new_host}")
  end

  def list_host
    get_hosts.each do |host|
      puts "#{host}"
    end
  end

  # Helper methods

  # Checks if the given host name is already in the git tree
  # If it is, throws an error and exits dotdash
  def check_if_host_taken(host)
    # variable assignment for more terse code
    hosts = get_hosts
    if hosts.include? host
      DotdashError.host_already_exists host
    end
  end

  # Checks that the given host name does actually exist
  def check_if_host_exists(host)
    hosts = get_hosts
    if not hosts.include? host
      DotdashError.host_does_not_exist host
    end
  end

  # Fetches a list of hosts.
  # Equivalent to the list of directories in DotdashBase::DIR 
  def get_hosts
    hosts = Dir.entries(@dir).select {|h| File.directory?(@dir + "/#{h}") and not h =~ /^[.]/ }
    return hosts
  end

  def dispatch_host(args)
    # do some stuff and call the right method in DotdashHost
    if args.empty? or args.size == 1
      puts "#{USAGE}"
      exit 1
    end
    op = args[0]
    host1 = args[1]
    if args.size >= 2
      host2 = args[2]
    end
    method = op + "_host"
    if ['clone', 'rename'].include? op and args.size >= 3
      self.send(method, host1, host2)
    elsif ['delete', 'create'].include? op
      self.send(method, host1)
    elsif op == 'list'
      self.send(method)
    else
      puts "Invalid subcommand: #{op}"
      puts "#{USAGE}"
      exit 1
    end
  end

end
