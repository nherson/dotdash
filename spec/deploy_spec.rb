require 'spec_helper'
require 'dotdash'
require 'fakefs/spec_helpers'


describe 'deploy' do

  include FakeFS::SpecHelpers

  before(:each) do
    #construct a makeshift Dotdash repo
    @dotdash = DotdashBase.new
    @dotdash.dir = '/homedir/.dotdash'
    FileUtils.mkdir_p(@dotdash.dir)
    @d = @dotdash.dir
    @home = '/homedir'
    Dir.mkdir(@d + '/hostA')
    Dir.mkdir(@d + '/hostB')
    Dir.mkdir(@d + '/hostC')
    Dir.mkdir(@d + '.git')
    File.new(@d + '/hostA/.zshrc', 'w')
    File.new(@d + '/hostA/.tmux.conf', 'w')
    File.new(@d + '/hostB/.zshrc', 'w')
    File.new(@d + '/hostB/.vimrc', 'w')
    File.new(@d + '/hostC/.vimrc', 'w')
    Dir.mkdir(@d + '/hostC/.ssh')
    File.new(@d + '/hostC/.ssh/config', 'w')
    # variables for convenience
    @hostA = @d + '/hostA'
    @hostB = @d + '/hostB'
    @hostC = @d + '/hostC'
    File.stub(:expand_path).and_return("/homedir")
  end

  it 'should drop the right files, given a certain host' do
    @dotdash.host = 'hostA'
    @dotdash.deploy
    File.exists?([@home, '.zshrc'].join('/')).should == true
    File.exists?([@home, '.tmux.conf'].join('/')).should == true
  end

  it 'should be able to handle copying dotfile directories' do
    @dotdash.host = 'hostC'
    @dotdash.deploy
    Dir.exists?([@home, '.ssh'].join('/')).should == true
    File.exists?([@home, '.ssh', 'config'].join('/')).should == true
  end
end
