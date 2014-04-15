module DotdashError

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

end
