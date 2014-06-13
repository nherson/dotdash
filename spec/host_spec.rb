require 'spec_helper'
require 'dotdash'
require 'fakefs/spec_helpers'


describe 'host' do

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
      @dotdash.create_host('hostD')
      Dir.exists?(@dotdash.dir + '/hostD').should == true
    end

    it 'should fail for taken hostnames' do
      DotdashError.should receive(:host_already_exists) { raise SystemExit }
      lambda { @dotdash.create_host('hostA') }.should raise_error SystemExit
    end
  end

  describe 'clone' do
    it 'should copy directory and contents upon success' do
      @dotdash.clone_host 'hostA', 'hostD'
      Dir.exists?(@dotdash.dir + 'hostD').should == true
      File.exists?(@dotdash.dir + 'hostD/.zshrc').should == true
      File.exists?(@dotdash.dir + 'hostD/.tmux.conf').should == true
    end

    it 'should fail given non-existent current host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { @dotdash.clone_host 'hostE', 'hostF' }.should raise_error SystemExit
    end

    it 'should fail given already existing host to clone to' do
      DotdashError.should receive(:host_already_exists) { raise SystemExit }
      lambda { @dotdash.clone_host 'hostA', 'hostB' }.should raise_error SystemExit
      Dir.exists?(@hostA).should == true
      Dir.exists?(@hostB).should == true
    end
  end

  describe 'delete' do
    it 'deletes entire host directories upon success' do
      @dotdash.delete_host 'hostA'
      Dir.exists?(@hostA).should == false
    end
    
    it 'fails when attempting to delete unknown host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { @dotdash.delete_host('hostE') }.should raise_error SystemExit 
    end
  end

  describe 'rename' do
    it 'properly renames, given good args' do
      @dotdash.rename_host('hostA', 'hostG')
      Dir.exists?('/hostG').should == true
    end

    it 'fails given nonexistent host' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      lambda { @dotdash.rename_host('hostE', 'hostF') }.should raise_error SystemExit
    end

    it 'fails given already existing destination host' do
      DotdashError.should receive(:host_already_exists) { raise SystemExit }
      lambda { @dotdash.rename_host('hostA', 'hostB') }.should raise_error SystemExit
    end

    it 'fails when making a trivial rename' do
      DotdashError.should receive(:host_already_exists) { raise SystemExit }
      lambda { @dotdash.rename_host('hostB', 'hostB') }.should raise_error SystemExit
    end
  end

  describe 'list' do
    it 'displays a proper list of hosts' do
      $stdout = StringIO.new
      @dotdash.list_host
      expect($stdout.string).to match /hostA\nhostB\nhostC/
    end

    it 'shows new hosts when they are added' do
      $stdout = StringIO.new
      Dir.mkdir '/hostX'
      @dotdash.list_host
      expect($stdout.string).to match /hostA\nhostB\nhostC\nhostX/
    end
  end

  describe 'dispatcher' do
    it 'calls list host, even if even too many args after it' do
      @dotdash.should receive(:list_host) { }
      @dotdash.dispatch_host(["list", "some", "more", "args"])
    end

    it 'create host calls create_host, even with extra args' do
      @dotdash.should receive(:create_host).with("hostX") { }
      @dotdash.dispatch_host(["create", "hostX", "extra", "args"])
    end

    it 'clone host calls clone_host' do
      @dotdash.should receive(:clone_host).with("hostX", "hostY") { }
      @dotdash.dispatch_host(["clone", "hostX", "hostY", "extra", "args"])
    end

    it 'delete host calls delete_host' do
      @dotdash.should receive(:delete_host).with("hostA") { }
      @dotdash.dispatch_host(["delete", "hostA"])
    end

    it 'rename host calls rename_host' do
      @dotdash.should receive(:rename_host).with("hostF", "hostG") { }
      @dotdash.dispatch_host(["rename", "hostF", "hostG"])
    end
  end

end
