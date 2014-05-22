# 
# Responsible for all work at the host level
#
module DotdashHost

  OPS_LIST = ['create',
              'clone',
              'delete',
              'rename',
              'list',
             ]

  def DotdashHost.create(host)
    DotdashHost.check_if_taken host
    # make the host (create the directory)
    Dir.mkdir(DotdashBase::DIR + "/#{host}")
  end

  def DotdashHost.clone(orig_host, new_host)
    d = DotdashBase::DIR
    DotdashHost.check_if_taken new_host 
    DotdashHost.check_if_exists orig_host
    FileUtils.cp_r(d + "/#{orig_host}", d + "/#{new_host}")
  end

  def DotdashHost.delete(host)
    # TODO add a confirmation prompt here
    d = DotdashBase::DIR
    DotdashHost.check_if_exists host
    FileUtils.rm_rf d+"/#{host}"
  end

  def DotdashHost.rename(old_host, new_host)
    # TODO add a confirmation prompt here
    d = DotdashBase::DIR
    DotdashHost.check_if_exists old_host
    DotdashHost.check_if_taken new_host
    FileUtils.mv(d+"/#{old_host}", d+"/#{new_host}")
  end

  def DotdashHost.list
    DotdashHost.get_hosts.each do |host|
      puts "#{host}"
    end
  end

  # Helper methods

  # Checks if the given host name is already in the git tree
  # If it is, throws an error and exits dotdash
  def DotdashHost.check_if_taken(host)
    # variable assignment for more terse code
    hosts = DotdashHost.get_hosts
    if hosts.include? host
      DotdashError.create_host_already_exists host
    end
  end

  # Checks that the given host name does actually exist
  def DotdashHost.check_if_exists(host)
    hosts = DotdashHost.get_hosts
    if not hosts.include? host
        DotdashError.host_does_not_exist host
    end
  end

  # Fetches a list of hosts.
  # Equivalent to the list of directories in DotdashBase::DIR 
  def DotdashHost.get_hosts
    d = DotdashBase::DIR
    hosts = Dir.entries(d).select {|h| File.directory?(d + "/#{h}") and not h =~ /^[.]/ }
    return hosts
  end

  def DotdashHost.method_missing(method, *args, &block)
    puts "#{method}"
    DotdashError.unknown_subcommand(method, OPS_LIST)
  end

end
