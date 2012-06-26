require 'spec_helper'

describe SimpleRoles::One do
  subject { SimpleRoles::One }
  let(:user) { User.create :role => 'user' }
  
  describe ".package" do
    before(:all) do
      SimpleRoles::One.package User
    end

    describe "Persistence" do
      it "should read role as symbol" do
        user.update_attribute :role, 'user'
        user.role.should == :user
      end

      it "should set roles" do
        user.role = :admin
        user.role.should == :admin
      end

      it "should persist roles" do
        user.role = :admin
        user.save
        user.role.should == :admin
      end
    end

    describe "Roles methods" do
      describe "#set_role" do
        it "should set role" do
          user.set_role(:admin)
          user.role.should == :admin
        end

        it "should persist role" do
          user.set_role(:admin)
          user.reload
          user.role.should == :admin
        end
      end

      describe "Dynamic scopes" do
        SimpleRoles.config.valid_roles.each do |r|
          specify { User.should respond_to :"#{r}s" }
        end
      end

      describe "Dynamic methods" do
        SimpleRoles.config.valid_roles.each do |r|
          specify { user.should respond_to :"#{r}?" }
        end

        describe "#user?, #admin?, ..." do
          specify do
            user.set_role(:admin)
            user.admin?.should == true

            user.set_role(:user)
            user.user?.should == true
          end
        end
        
        describe "#is_user?, #is_admin?, ..." do
          specify do
            user.set_role(:admin)
            user.is_admin?.should == true

            user.set_role(:user)
            user.is_user?.should == true
          end
        end
      end
    end
  end
end
