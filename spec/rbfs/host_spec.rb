require 'rbfs/host'

describe Rbfs::Host do
  def test_example(line, ip, name=nil, alias_name=nil)
    host = Rbfs::Host.new(line)
    host.ip.should eql(ip)
    host.name.should eql(name)
    host.alias.should eql(alias_name)
  end

  it "should handle minimal syntax" do
    test_example("1.1.1.1", "1.1.1.1")
  end

  it "should handle basic syntax" do
    test_example("1.1.1.1 HOSTNAME", "1.1.1.1", "HOSTNAME")
  end

  it "should handle advanced syntax" do
    test_example("1.1.1.1 HOSTNAME HOST", "1.1.1.1", "HOSTNAME", "HOST")
  end

  it "should support tab separation" do
    test_example("1.1.1.1\tHOSTNAME", "1.1.1.1", "HOSTNAME")
  end

  it "should tolerate lots of tab separation" do
    test_example("1.1.1.1\t\t\t\t\t\t\tHOSTNAME", "1.1.1.1", "HOSTNAME")
  end

  it "should tolerate lots of spaces" do
    test_example("1.1.1.1        HOSTNAME", "1.1.1.1", "HOSTNAME")
  end

  it "should tolerate lots of aliases" do
    test_example("1.1.1.1 HOSTNAME HOSTA HOSTB HOSTC HOSTD", "1.1.1.1", "HOSTNAME", "HOSTA")
  end
end
