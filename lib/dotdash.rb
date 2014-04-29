require 'parseconfig'
require 'dotdash/file'
require 'dotdash/error'
require 'dotdash/host'
require 'dotdash/git'

module DotdashBase

  # should have some basic config options and things
  # parsed up and ready to be accessed by other classes
  # that include this one

  DotdashBase::DIR = "~/.dotdash"

  def DotdashBase.fetch_repo
    begin
      repo = DotdashGit.get_repo
      DotdashBase.const_set(:GIT_REPO, repo)
    rescue
      DotdashError.fetch_repo_error
    end
  end

  def DotdashBase.parse_opts
    # make sure the git repo is set, else we have problems
    config = DotdashBase.get_config
    if config["git_repo_url"] == nil
      DotdashError.no_repo_specified
    end
    # set each config option in the file, even if they dont mean anything!
    config.each do |key,val|
      DotdashBase.const_set(key.upcase, val)
    end
    #check the config options that need it
    if config["editor"] != nil and not system("which #{config["editor"]}")
      DotdashError.editor_not_found
    end
  end

  def DotdashBase.get_config
    config = ParseConfig.new(File.expand_path('~/.dotdash.conf'))
    config.get_params
  end

  # Where the magic happens (but not really)
  def DotdashBase.deploy(args = nil)
    if args != nil
      host = args[0]
    else
      # get the local hostname to deploy
      host = `hostname -s`.strip
    end
    DotdashHost.check_if_exists host
    puts "Deploying..."
    files = Dir.glob(DotdashBase::DIR + "/host/*")
    home = File.expand_path("~")
    FileUtils.cp_r files home
    puts "Done!"
  end

end


