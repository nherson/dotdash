require 'spec_helper'
require 'dotdash'
require 'parseconfig'

describe "parsing config file" do
  before(:each) do
    DotdashBase.constants.each do |con|
      DotdashBase.send(:remove_const, con)
    end
  end

  it "should have no issue for a valid config" do
    opts = {"git_repo_url" => "GIT_REPO_LOCATION"}
    DotdashBase.stub(:get_config).and_return(opts)
    DotdashBase.parse_opts
    expect(DotdashBase::GIT_REPO_URL).to eq("GIT_REPO_LOCATION")
  end

  it "should assign any arbitrary config in the config file" do
    opts = {
            "optionA" => "some_parameter",
            "optionB" => "another_setting",
            "settingC" => "foobar",
            "git_repo_url" => "GIT_PLACE"
           }
    DotdashBase.stub(:get_config).and_return(opts)
    DotdashBase.parse_opts
    expect(DotdashBase::OPTIONA).to eq("some_parameter")
    expect(DotdashBase::OPTIONB).to eq("another_setting")
    expect(DotdashBase::SETTINGC).to eq("foobar")
    expect(DotdashBase::GIT_REPO_URL).to eq("GIT_PLACE")
  end

  it "should raise an error when listing a bad editor" do
    opts = {
            "git_repo_url" => "place",
            "editor" => "nonexistent_vim_clone",
           }
    Kernel.stub(:system).and_return(false)
    DotdashBase.stub(:get_config).and_return(opts)
    DotdashError.should_receive(:editor_not_found)
    DotdashBase.parse_opts
  end


end
