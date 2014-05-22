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

  def list_hosts
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
      DotdashError.create_host_already_exists host
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

end
