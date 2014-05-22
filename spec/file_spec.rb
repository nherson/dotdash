require 'spec_helper'
require 'dotdash'
require 'fakefs/spec_helpers'


describe 'file' do

  include FakeFS::SpecHelpers

  before(:each) do
    #construct a makeshift Dotdash repo
    @dotdash = DotdashBase.new
    @dotdash.dir = '/'
    Dir.mkdir('hostA')
    Dir.mkdir('hostB')
    Dir.mkdir('hostC')
    Dir.mkdir('.git')
    File.new('hostA/.zshrc', 'w')
    File.new('hostA/.tmux.conf', 'w')
    File.new('hostB/.zshrc', 'w')
    File.new('hostB/.vimrc', 'w')
    File.new('hostC/.vimrc', 'w')
    Dir.mkdir('hostC/.ssh')
    File.new('hostC/.ssh/config', 'w')
    # variables for convenience
    @hostA = '/hostA'
    @hostB = '/hostB'
    @hostC = '/hostC'
  end

  describe 'create' do
    it 'should create directory when given valid hostname' do
      pending "file specs pending"
    end

    it 'should fail for taken hostnames' do
      pending "file specs pending"
    end
  end

  describe 'delete' do
    it 'deletes the file from the default host given 1 arg' do
      pending "file specs pending"
    end
  end

end
