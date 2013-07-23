require 'rbfs/rsync'

describe Rbfs::Rsync do
  it "should run_command" do
    Rbfs::Rsync.new.run_command("echo test").should eql("test\n")
  end

  it "should run_command block" do
    Rbfs::Rsync.new.run_command("echo test") do |io|
      io.read.should eql("test\n")
    end
  end

  it "should command" do
    Rbfs::Rsync.new.command("echo", ["test"])[:output].should eql("test\n")
  end

  it "should command block" do
    Rbfs::Rsync.new.command("echo", ["test"]) do |io|
      io.read.should eql("test\n")
    end
  end
end
