require 'spec_helper'

describe "Transactions test" do
  specify "We create some records" do
    3.times do
      create :one_user
      create :user
    end
  end

  specify "All tables must empty" do
    OneUser.count.should == 0
    User.count.should == 0
  end
end
