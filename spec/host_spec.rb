require 'spec_helper'
require 'dotdash'
#require 'fakefs'
require 'fakefs/spec_helpers'


describe 'host' do

  include FakeFS::SpecHelpers

  before(:each) do
    #construct a makeshift Dotdash repo
    FileUtils.mkdir_p(DotdashBase::DIR)
    @d = DotdashBase::DIR
    Dir.mkdir(@d + '/hostA')
    Dir.mkdir(@d + '/hostB')
    Dir.mkdir(@d + '/hostC')
    Dir.mkdir(@d + '/.git')
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
  end

  describe 'create' do
    it 'should create directory when given valid hostname' do
      DotdashHost.create('hostD')
      Dir.exists?(DotdashBase::DIR + '/hostD').should == true
    end

    it 'should fail for taken hostnames' do
      DotdashError.should receive(:create_host_already_exists) { raise SystemExit }
      lambda { DotdashHost.create('hostA') }.should raise_error SystemExit
    end
  end

  describe 'clone' do
    it 'should copy directory and contents upon success' do
      DotdashHost.clone 'hostA', 'hostD'
      Dir.exists?(DotdashBase::DIR + '/hostD').should == true
      File.exists?(DotdashBase::DIR + '/hostD/.zshrc').should == true
      File.exists?(DotdashBase::DIR + '/hostD/.tmux.conf').should == true
    end

    it 'should fail given non-existent current host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { DotdashHost.clone 'hostE', 'hostF' }.should raise_error SystemExit
    end

    it 'should fail given already existing host to clone to' do
      DotdashError.should receive(:create_host_already_exists) { raise SystemExit }
      lambda { DotdashHost.clone 'hostA', 'hostB' }.should raise_error SystemExit
      Dir.exists?(@d + '/hostA').should == true
      Dir.exists?(@d + '/hostB').should == true
    end
  end

  describe 'delete' do
    it 'deletes entire host directories upon success' do
      DotdashHost.delete 'hostA'
      Dir.exists?(@d + '/hostA').should == false
    end
    
    it 'fails when attempting to delete unknown host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { DotdashHost.delete('hostE') }.should raise_error SystemExit 
    end
  end

  describe 'rename' do
    it 'properly renames, given good args' do
      DotdashHost.rename('hostA', 'hostG')
      Dir.exists?(@d + '/hostG').should == true
    end

    it 'fails given nonexistent host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { DotdashHost.rename('hostE', 'hostF') }.should raise_error SystemExit
    end

    it 'fails given already existing destination host' do
      DotdashError.should receive(:create_host_already_exists) { raise SystemExit }
      lambda { DotdashHost.rename('hostA', 'hostB') }.should raise_error SystemExit
    end

    it 'fails when making a trivial rename' do
      DotdashError.should receive(:create_host_already_exists) { raise SystemExit }
      lambda { DotdashHost.rename('hostB', 'hostB') }.should raise_error SystemExit
    end
  end

  describe 'list' do
    it 'displays a proper list of hosts' do
      $stdout = StringIO.new
      DotdashHost.list
      expect($stdout.string).to match /hostA\nhostB\nhostC/
    end

    it 'shows new hosts when they are added' do
      $stdout = StringIO.new
      Dir.mkdir @d + '/hostX'
      DotdashHost.list
      expect($stdout.string).to match /hostA\nhostB\nhostC\nhostX/
    end
  end

end
