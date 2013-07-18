require 'rbfs/host_parser'
require 'stringio'

describe Rbfs::HostParser do
  def test_case(string, size)
    io = StringIO.new(string)
    hp = Rbfs::HostParser.new(io)
    hp.collect {|v|v}.length.should eql(size)
  end

  it "should handle a file with only comments" do
    test_case("# TEST", 0)
  end

  it "should handle a file with one host" do
    test_case("1.1.1.1 HOSTNAME", 1)
  end

  it "should handle a basic file" do
    test_case("# TEST\n1.1.1.1 HOSTNAME", 1)
  end

  it "should handle empty lines" do
    test_case("\n\n# TEST\n1.1.1.1 HOSTNAME\n\n", 1)
  end

  it "should handle multiple lines" do
    test_case("1.1.1.1 HOSTNAME\n1.1.1.1 HOSTNAME\n1.1.1.1 HOSTNAME", 3)
  end
end
