describe Carrier::Message do
  concern "Scopes" do
    before(:all) do
      Carrier::Message.delete_all
      Carrier::Chain.delete_all
    end

    specify {
      Message.count.should == 0
      Chain.count.should == 0
      Message.for_or_by(User.first).size.should == 0
      create(:first_message)
      Message.for(User.first).size.should == 0
      Message.by(User.first).size.should == 1
      Message.for_or_by(User.first).size.should == 1
      create(:second_message)
      Message.for(User.first).size.should == 1
      Message.by(User.first).size.should == 1
      Message.for_or_by(User.first).size.should == 2
    }
  end
end
