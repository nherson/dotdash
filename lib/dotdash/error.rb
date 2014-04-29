module DotdashError

  def DotdashError.general_usage
    puts "There will be some general usage info here"
    exit 1
  end

  def DotdashError.unknown_subcommand(arg)
    puts "Unknown subcommand: #{arg}"
    puts "Available commands go here...."
    exit 1
  end

  def DotdashError.config_not_found
    puts "config file not found at #{File.expand_path('~/.dotdash.conf')}"
    exit 1
  end

  def DotdashError.no_repo_specified
    puts "No git repo configured in #{File.expand_path('~/.dotdash.conf')}"
    puts "You should add a git repo which you can pull from and push to:"
    puts 'e.g.     git_repo_url = git@github.com:MY_USERNAME/MY_DOTDASH_REPO'
    exit 1
  end

  def DotdashError.editor_not_found
    puts "A custom editor is specified in your config, but it could not be found"
    exit 1
  end

  def DotdashError.open_repo_error
    puts "There was a problem opening the git repository"
    exit 1
  end

  def DotdashError.git_repo_already_exists
    puts "A git repo seems to already exist in #{File.expand_path('~/.dotdash.conf')}"
    puts "Perhaps your dotdash repo is already setup?"
    exit 1
  end

  def DotdashError.dotdash_directory_exists
    puts "The directory #{File.expand_path('~/.dotdash.conf')} already exists,"
    puts "and it does not appear to be a git repo.  Please fix the issue and "
    puts "try running 'dotdash init' again"
    exit 1
  end

  def DotdashError.clone_repo_error
    puts "There was an error cloning the dotdash repo from the URL given"
    exit 1
  end

  def DotdashError.fetch_repo_error
    puts "There was a problem fetching the remote repository"
    exit 1
  end

  def DotdashError.create_host_already_exists(host)
    puts "The host #{host} already exists in the repo."
    exit 1
  end

  def DotdashError.host_does_not_exist(host)
    puts "The host #{host} does not exist in the repo."
    exit 1
  end

end
