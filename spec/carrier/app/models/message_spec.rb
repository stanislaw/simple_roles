require 'dummy_spec_helper'

describe Carrier::Message do
   describe 'Carrier::Message class' do
     subject {Carrier::Message}
       its(:table_name) { should == Carrier.config.models.table_for(:message) }
       
       describe "#find_recipients" do
         it "should return all recipients" do
           pending
         end
       end
   end 
    
  it { should belong_to(:chain) }
  
  it "should serialize .recipients field" do
    subject.recipients.should == []
  end

  concern "Validations" do
    it "should not save messages with empty .content field" do
      lambda {
        subject.content = ''
        subject.save!
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
    it "should not save messages with wrong recipients" do
      lambda {
        subject.sender = 1
        subject.content = 'something'
        subject.save!
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
