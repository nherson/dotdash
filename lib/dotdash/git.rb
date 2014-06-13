require 'git'

module DotdashGit

  def open_repo
    begin
      repo = Git.open("~/.dotdash")
      return repo
    rescue
      DotdashError.open_repo_error
    end
  end

  def init_repo
    if File.file?(@dir) or File.directory?(@dir)
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

  def push
    self.pull
    self.git_repo.add(:all => true)
    self.git_repo.push
  end

  def pull
    self.git_repo.pull
  end

end
