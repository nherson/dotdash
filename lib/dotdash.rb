require 'parseconfig'
require 'dotdash/file'
require 'dotdash/error'

module DotdashBase

  # should have some basic config options and things
  # parsed up and ready to be accessed by other classes
  # that include this one
  
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
end


