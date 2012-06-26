require 'spec_helper'

describe do
  specify do
    User.create :username => "Stanislaw"
  end

  specify do
    User.count.should == 0
  end
end
