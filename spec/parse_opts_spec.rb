require 'spec_helper'
require 'dotdash'

describe "parse_opts" do
  before(:each) do
    @base = DotdashBase.new
    @base.stub(:check_if_host_exists).and_return(nil)
  end

  it "should have no issue for a valid config" do
    opts = {"git_repo_url" => "GIT_REPO_LOCATION",
            "host" => "my_host",
           }
    @base.stub(:get_config).and_return(opts)
    @base.parse_opts
    expect(@base.git_repo_url).to eq("GIT_REPO_LOCATION")
    expect(@base.host).to eq("my_host")
  end

  it "should not crash when given arbitrary options" do
    opts = {
            "optionA" => "some_parameter",
            "optionB" => "another_setting",
            "settingC" => "foobar",
            "git_repo_url" => "GIT_PLACE"
           }
    @base.stub(:get_config).and_return(opts)
  end

  it "should raise an error when listing a bad editor" do
    opts = {
            "git_repo_url" => "place",
            "editor" => "nonexistent_vim_clone",
           }
    Kernel.stub(:system).and_return(false)
    @base.stub(:get_config).and_return(opts)
    DotdashError.should_receive(:editor_not_found)
    @base.parse_opts
  end


end
