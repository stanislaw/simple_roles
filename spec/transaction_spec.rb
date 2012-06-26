require 'spec_helper'

describe do
  specify do
    OneUser.create :username => "Stanislaw"
  end

  specify do
    OneUser.count.should == 0
  end
end
