require 'rbfs/command'
require 'tmpdir'

describe Rbfs::Command do
  def make_test_dir(&block)
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      File.open(File.join(@tmpdir, "hosts"), 'w') {|f| f.write("127.0.0.1 testhost")}
      Dir.mkdir(File.join(@tmpdir, "local"))
      Dir.mkdir(File.join(@tmpdir, "remote"))
      yield
    end
  end

  # /sample.txt
  def build_simple
    File.open(File.join(@tmpdir, "local", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  # /somepath/sample.txt
  def build_subpath_simple
    Dir.mkdir(File.join(@tmpdir, "local", "somepath"))
    File.open(File.join(@tmpdir, "local", "somepath", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  # /somepath/someotherpath/sample.txt
  def build_deeppath_simple
    Dir.mkdir(File.join(@tmpdir, "local", "somepath"))
    Dir.mkdir(File.join(@tmpdir, "local", "somepath", "someotherpath"))
    File.open(File.join(@tmpdir, "local", "somepath", "someotherpath", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  def get_tree(subpath)
    `cd #{@tmpdir}/#{subpath}; tree`
  end

  def run_sync_test
    Rbfs::Command.new(
      :hosts => File.join(@tmpdir, "hosts"),
      :root => File.join(@tmpdir, "local"),
      :remote_root => File.join(@tmpdir, "remote")
    ).sync
    get_tree("remote").should eql(get_tree("local"))
  end

  def run_deeppath_test(subpath)
    build_deeppath_simple
    Rbfs::Command.new(
      :hosts => File.join(@tmpdir, "hosts"),
      :root => File.join(@tmpdir, "local"),
      :subpath => subpath,
      :remote_root => File.join(@tmpdir, "remote")
    ).sync
    get_tree("remote").should eql(get_tree("local"))
  end

  context "simple", :local => true do
    around(:each) do |example|
      make_test_dir do
        example.run
      end
    end

    it "should do simple file sync" do
      build_simple
      Rbfs::Command.new(
        :hosts => File.join(@tmpdir, "hosts"),
        :root => File.join(@tmpdir, "local") + "/sample.txt",
        :remote_root => File.join(@tmpdir, "remote") + "/sample.txt"
      ).sync
      get_tree("remote").should eql(get_tree("local"))
    end

    it "should do simple path sync" do
      build_simple
      run_sync_test
    end

    it "should do multi path sync" do
      build_subpath_simple
      run_sync_test
    end

    it "should do sub path sync" do
      run_deeppath_test("somepath")
    end

    it "should do deep sub path sync" do
      run_deeppath_test("somepath/someotherpath")
    end

    it "should do deep sub path file sync" do
      run_deeppath_test("somepath/someotherpath/sample.txt")
    end
  end
end
