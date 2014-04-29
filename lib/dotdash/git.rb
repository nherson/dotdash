require 'git'

module DotdashGit

  def DotdashGit.get_repo
    begin
      repo = Git.open("~/.dotdash")
      return repo
    rescue
      DotdashError.open_repo_error
    end
  end

  def DotdashGit.init_repo
    dotdash_dir = DotdashBase::DIR
    if File.file?(dotdash_dir) or File.directory?(dotdash_dir)
      begin
        repo = Git.open("~/.dotdash")
        DotdashError.git_repo_already_exists
      rescue ArgumentError
        DotdashError.dotdash_directory_exists
      end
    else
      begin
        Git.clone(DotdashBase::GIT_REPO_URL, dotdash_dir, {})
      rescue Git::GitExecuteError
        DotdashError.clone_repo_error
      end
      puts "Dotdash repo setup successfully!"
    end
  end

  # Stubs, to be implemented later

  def DotdashGit.push
  end

  def DotdashGit.pull
  end

  def DotdashGit.commit
  end

end
