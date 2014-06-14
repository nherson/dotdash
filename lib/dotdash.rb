require 'parseconfig'
require 'dotdash/file'
require 'dotdash/error'
require 'dotdash/host'
require 'dotdash/git'

class DotdashBase

  # should have some basic config options and things
  # parsed up and ready to be accessed by other classes
  # that include this one

  include DotdashHost
  include DotdashFile
  include DotdashGit
  
  # these are all of the settings needed to operate
  OPTIONS = ['dir', 'editor', 'git_repo_url', 'host']

  attr_accessor :dir, :editor, :git_repo_url, :host, :git_repo

  def fetch_repo
    begin
      @git_repo = self.get_repo
    rescue
      DotdashError.fetch_repo_error
    end
  end

  def parse_opts
    # make sure the git repo is set, else we have problems
    config = get_config
    # first just try setting all the values,
    # dropping invalid options
    config.each do |key,val|
      if OPTIONS.include? key
        self.send(key + '=', val)
      end
    end
    # check for default local repo location
    if @dir == nil
      @dir = File.expand_path('~/.dotdash')
    end
    if @git_repo_url == nil
      DotdashError.no_repo_specified
    end
    # set editor to user's editor if not in config file
    if @editor == nil
      @editor = "$EDITOR"
    end
    # check that editor is valid
    if not Kernel.send(:`, "which #{@editor}")
      DotdashError.editor_not_found
    end
    # check for specified host
    if @host == nil
      @host = `hostname -s`.strip
      check_if_host_exists @host
    end
  end

  def get_config
    config = ParseConfig.new(File.expand_path('~/.dotdash.conf'))
    config.get_params
  end

  # Where the magic happens (but not really)
  def deploy(host = nil)
    if host == nil
      host = @host
    end
    puts "Deploying..."
    files = Dir.glob([@dir, host, '*'].join('/'))
    home = File.expand_path("~")
    files.each do |file|
      FileUtils.cp_r file, home
    end
    puts "Done!"
  end

end


