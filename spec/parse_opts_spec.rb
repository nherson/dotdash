require 'spec_helper'
require 'dotdash'
require 'parseconfig'

describe "parsing config file" do
  it "should have no issue for a valid config" do
    opts = {"git_repo_url" => "GIT_REPO_LOCATION"}
    DotdashBase.stub(:get_config).and_return(opts)
    DotdashBase.parse_opts
    puts "#{DotdashBase.constants} <==== CONS"
    expect(DotdashBase::GIT_REPO_URL).to eq("GIT_REPO_LOCATION")
  end
end
