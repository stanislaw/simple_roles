require 'spec_helper'

describe do
  specify do
    3.times do
      create :one_user
      create :user
    end
  end

  specify do
    OneUser.count.should == 0
    User.count.should == 0
  end
end
