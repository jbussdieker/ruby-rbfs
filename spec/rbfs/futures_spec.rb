require 'rbfs/futures'

describe Rbfs::Future do
  it "should be creatable" do
    Rbfs::Future.new.should be_kind_of(Object)
  end
end
