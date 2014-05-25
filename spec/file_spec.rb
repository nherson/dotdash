require 'spec_helper'
require 'dotdash'
require 'fakefs/spec_helpers'


describe 'file' do

  include FakeFS::SpecHelpers

  before(:each) do
    #construct a makeshift Dotdash repo
    @dotdash = DotdashBase.new
    @dotdash.dir = '/homedir/.dotdash'
    FileUtils.mkdir_p(@dotdash.dir)
    @d = @dotdash.dir
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
    # some random files (for importing)
    File.new('/homedir/.zshrc', 'w')
    File.new('/homedir/.screenrc', 'w')
    FileUtils.mkdir_p('/etc/some/dir')
    File.new('/etc/some/dir/.dotfile', 'w')
    File.new('/etc/some/dir/.dotfile2','w')
  end

  describe 'delete' do
    it 'removes the file, given that it exists' do
      @dotdash.host = 'hostA'
      @dotdash.delete_file('.zshrc')
      File.exists?(@hostA + '/.zshrc').should == false
    end

    it 'removes the proper file when given non-default host' do
      @dotdash.host = 'hostA'
      @dotdash.delete_file('.zshrc', 'hostB')
      File.exists?(@hostA + '/.zshrc').should == true
      File.exists?(@hostB + '/.zshrc').should == false
    end

    it 'removes an entire directory when given' do
      @dotdash.host = 'hostC'
      @dotdash.delete_file('.ssh')
      Dir.exists?(@hostC + '/.ssh').should == false
    end

    it 'fails when asking to delete a non-existent file' do
      @dotdash.host = 'hostA'
      DotdashError.should receive(:file_not_found) { raise SystemExit }
      lambda { @dotdash.delete_file('.vimrc') }.should raise_error SystemExit
    end
  end

  describe 'clone' do
    it 'copies to configured host when none is specified' do
      @dotdash.host = 'hostA'
      @dotdash.clone_file 'hostC', '.vimrc'
      File.exists?(@hostA + '/.vimrc').should == true
    end

    it 'copies an entire directory when specified' do
      @dotdash.host = 'hostA'
      @dotdash.clone_file 'hostC', '.ssh'
      Dir.exists?(@hostA + '/.ssh').should == true
      File.exists?(@hostA + '/.ssh/config').should == true
    end

    it 'works when given a non-default dest_host' do
      @dotdash.host = 'hostA'
      @dotdash.clone_file 'hostB', '.zshrc', 'hostC'
      File.exists?(@hostC + '/.zshrc').should == true
    end

    it 'fails when source host does not exist' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      @dotdash.host = 'hostC'
      lambda { @dotdash.clone_file('hostD', '.zshrc') }.should raise_error SystemExit
    end

    it 'fails when destination host does not exist' do
      DotdashError.should receive(:host_does_not_exist) { raise SystemExit }
      @dotdash.host = 'hostC'
      lambda { @dotdash.clone_file('hostA', '.zshrc', 'hostE') }.should raise_error SystemExit
    end

    it 'fails when destination already contains file' do
      DotdashError.should receive(:file_already_exists) { raise SystemExit }
      @dotdash.host = 'hostA'
      lambda { @dotdash.clone_file('hostB', '.zshrc') }.should raise_error SystemExit
    end

    it "succeeds when copying file from dir that doesn't exist in dest" do
      @dotdash.host = 'hostA'
      @dotdash.clone_file 'hostC', '.ssh/config'
      File.exists?(@hostA + '/.ssh/config').should == true
    end

  end

  describe 'import' do
    before(:each) do
      File.stub(:expand_path).with("~").and_return("/homedir")
    end
    it 'defaults to looking in the homedir for the file' do
      @dotdash.host = 'hostA'
      @dotdash.import_file '.screenrc'
      File.exists?('/homedir/.dotdash/hostA/.screenrc').should == true
    end

    it 'follows an absolute path if path starts with /' do
      @dotdash.host = 'hostB'
      @dotdash.import_file '/etc/some/dir/.dotfile'
      File.exists?('/homedir/.dotdash/hostB/.dotfile').should == true
    end

    it 'allows copying entire directories' do
      @dotdash.host = 'hostC'
      @dotdash.import_file '/etc/some/dir'
      Dir.exists?('/homedir/.dotdash/hostC/dir').should == true
      File.exists?('/homedir/.dotdash/hostC/dir/.dotfile').should == true
      File.exists?('/homedir/.dotdash/hostC/dir/.dotfile2').should == true
    end

    it 'allows specifying non-default hosts' do
      @dotdash.host = 'hostA'
      @dotdash.import_file '.screenrc', 'hostB'
      File.exists?('/homedir/.dotdash/hostA/.screenrc').should == false
      File.exists?('/homedir/.dotdash/hostB/.screenrc').should == true
    end

    it 'fails when file already exists' do
      @dotdash.host = 'hostA'
      DotdashError.should receive(:file_already_exists) { raise SystemExit }
      lambda { @dotdash.import_file '.zshrc' }.should raise_error SystemExit
    end

    it 'fails when file is not found on system' do
      @dotdash.host = 'hostA'
      DotdashError.should receive(:system_file_not_found) { raise SystemExit }
      lambda { @dotdash.import_file 'thisdoesntexist' }.should raise_error SystemExit
    end
  end

  describe 'edit' do
    it 'allows editting when the file exists' do
      cmd = 'boop /homedir/.dotdash/hostA/.zshrc'
      Kernel.should receive(:`).with(cmd) { true }
      @dotdash.editor = 'boop'
      @dotdash.host = 'hostA'
      @dotdash.edit_file('.zshrc')
    end

    it 'fails when file does not exist' do
      @dotdash.host = 'hostB'
      Kernel.stub(:`) { true }
      DotdashError.should receive(:file_not_found) { raise SystemExit }
      lambda { @dotdash.edit_file('nonexistent_file.exe') }.should raise_error SystemExit
    end

    it 'allows specification of non-default hosts' do
      cmd = 'beep /homedir/.dotdash/hostB/.vimrc'
      Kernel.should receive(:`).with(cmd) { true }
      @dotdash.host = 'hostA'
      @dotdash.editor = 'beep'
      @dotdash.edit_file('.vimrc', 'hostB')
    end
  end

  describe 'dispatcher' do
    pending 'test suite not written'
  end

end
