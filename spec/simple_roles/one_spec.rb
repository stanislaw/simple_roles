require 'spec_helper'

describe SimpleRoles::One do
  subject { SimpleRoles::One }
  let(:user) { create :one_user, :role => 'user' }
  
  before(:all) do
    SimpleRoles::Packager.package OneUser, :one
  end

  describe "Persistence" do
    describe "#role" do
      it "should return nil if there is no role for user" do
        user.role = nil
        user.role.should == nil
      end

      it "should read role as symbol" do
        user.update_attribute :role, 'user'
        user.role.should == :user
      end
    end

    describe "#role=" do
      it "should set roles" do
        user.role = :admin
        user.role.should == :admin
      end

      it "should also accept strings" do
        user.role = 'admin'
        user.role.should == :admin
      end

      it "should not persist roles" do
        user.role = :admin
        user.reload
        user.role.should == :user
      end

      it "should not allow non-valid role" do
        expect {
          user.role = :wrong!
        }.to raise_error
      end
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
    
    describe "#update_role" do
      it "should set role" do
        user.update_role(:admin)
        user.role.should == :admin
      end

      it "should persist role" do
        user.update_role(:admin)
        user.reload
        user.role.should == :admin
      end
    end

    it "#has_role?" do
      user.role = :admin

      user.has_role?(:admin).should be_true
      user.has_role?(:editor).should be_false

      user.role = :user

      user.has_role?(:user).should be_true
      user.has_role?(:admin).should be_false
    end

    it "#has_any_role?" do
      user.role = :admin

      user.has_any_role?(:admin, :editor).should be_true
      user.has_any_role?(:editor, :user).should be_false
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
