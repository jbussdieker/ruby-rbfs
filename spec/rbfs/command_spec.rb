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

  def build_simple_test_dir
    File.open(File.join(@tmpdir, "local", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  def build_multipath_test_dir
    Dir.mkdir(File.join(@tmpdir, "local", "somepath"))
    File.open(File.join(@tmpdir, "local", "somepath", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  def build_deeppath_test_dir
    Dir.mkdir(File.join(@tmpdir, "local", "somepath"))
    Dir.mkdir(File.join(@tmpdir, "local", "somepath", "someotherpath"))
    File.open(File.join(@tmpdir, "local", "somepath", "someotherpath", "sample.txt"), 'w') do |f|
      f.write("hello world!")
    end
  end

  def get_tree(subpath)
    `cd #{@tmpdir}/#{subpath}; tree`
  end

  context "simple" do
    around(:each) do |example|
      make_test_dir do
        example.run
      end
    end

    it "should do simple file sync" do
      build_simple_test_dir
      Rbfs::Command.new(
        :hosts => File.join(@tmpdir, "hosts"),
        :root => File.join(@tmpdir, "local") + "/sample.txt",
        :remote_root => File.join(@tmpdir, "remote") + "/sample.txt"
      ).sync
      get_tree("local").should eql(get_tree("remote"))
    end

    it "should do simple path sync" do
      build_simple_test_dir
      Rbfs::Command.new(
        :hosts => File.join(@tmpdir, "hosts"),
        :root => File.join(@tmpdir, "local"),
        :remote_root => File.join(@tmpdir, "remote")
      ).sync
      get_tree("local").should eql(get_tree("remote"))
    end

    it "should do multi path sync" do
      build_multipath_test_dir
      Rbfs::Command.new(
        :hosts => File.join(@tmpdir, "hosts"),
        :root => File.join(@tmpdir, "local"),
        :remote_root => File.join(@tmpdir, "remote")
      ).sync
      get_tree("local").should eql(get_tree("remote"))
    end

    it "should do sub path sync" do
      build_deeppath_test_dir
      Rbfs::Command.new(
        :hosts => File.join(@tmpdir, "hosts"),
        :root => File.join(@tmpdir, "local"),
        :subpath => "somepath/someotherpath/",
        :remote_root => File.join(@tmpdir, "remote")
      ).sync
      get_tree("local").should eql(get_tree("remote"))
    end
  end
end
