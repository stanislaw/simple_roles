require 'spec_helper'

SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
end

describe SimpleRoles::Base do

  before(:each) do
    setup_roles
  end

  context "Class Methods" do 
    subject { User }

    context "Scopes" do
      before do
      end
      
      SimpleRoles::Configuration.valid_roles.each do |vr|
        it {should respond_to(:"#{vr}s")}
        it {should respond_to(:"#{vr}s_ids")}

        its(:"#{vr}s") { should be_kind_of(Array) }
      end

    end
    specify { should respond_to(:valid_roles) }
    its(:valid_roles) { should include(:user, :admin)}
  end

  context "Instance methods" do
    subject {User.new}
   
    [:db_roles, :user_roles].each do |meth|
      specify { should respond_to(meth) }
      its(:"#{meth}") { should be_empty }
    end

    [:roles, :roles_list].each do |meth|
      specify { should respond_to(meth) }
      its(:"#{meth}") { should be_empty }
    end

    context "#roles" do
      it "call on #roles.clear should raise error" do
        lambda { 
          roles.clear
        }.should raise_error
      end
    end

  end

  context "Read API" do
    subject do
      @user ||= User.new(:name => "stanislaw")
    end

    it "#has_role?, #has_roles?" do
      subject.roles << :admin
      subject.has_role?(:admin).should be_true
      subject.has_role?(:admin, :user).should be_false
      subject.has_roles?(:editor).should be_false
      subject.roles << :user
      subject.has_role?(:admin, :user).should be_true
      subject.has_role?([:admin, :user]).should be_true
    end

    it "#admin?, #user?, #editor? ..." do
      subject.roles << :admin
      subject.admin?.should be_true
      subject.is_admin?.should be_true
      subject.user?.should be_false
      subject.editor?.should be_false
      subject.roles << :editor
      subject.editor?.should be_true
    end
  end
  
  context "Write API" do
    subject do
      @user ||= User.new(:name => "stanislaw")
    end

    it "#roles= should set roles" do
      subject.roles = :admin
      subject.roles.should == Array.new([:admin])
      subject.roles = :user
      subject.roles.should == Array.new([:user])
    end

    it "#roles= should set roles if array of strings passed (sh accept strings too!)" do
      subject.roles = 'admin'
      subject.roles.should == Array.new([:admin])
      subject.roles = ['user', 'editor']
      subject.roles.should == Array.new([:user, :editor])
    end
    
    it "#roles << should add roles" do
      subject.roles << :admin
      subject.roles.should == Array.new([:admin])
      subject.roles << :user
      subject.roles.should == Array.new([:admin, :user])
    end

    it "#remove_roles should remove roles" do
      subject.roles << :admin
      subject.roles << :user
      subject.roles << :editor

      subject.roles.should == Array.new([:admin, :user, :editor])
 
      subject.remove_roles :admin
      subject.roles.should == Array.new([:user, :editor])
  
      subject.remove_roles :admin, :user, :editor
      subject.roles.should == Array.new([])
    end
  end

  context "Integration for roles methods" do
    it "should work when #flatten is called over #roles" do
      user = User.new(:name => "stanislaw")
      user.roles << :admin
      
      user.roles_list.should == Array.new([:admin])
      user.roles_list.flatten.should == Array.new([:admin])
    end
    
    it "should add :roles to accessible_attributes if they are Whitelisted" do
      user = User.new(:name => "stanislaw")
      user.roles << :admin

      user.roles_list.should include(:admin)
      user.save!
      User.find_by_name!("stanislaw").should be_kind_of(User)
      User.delete_all

      User.attr_accessible :name
        
      user = User.new(:name => "stanislaw")
      user.roles << :admin
      user.roles_list.should include(:admin)
      user.save!
      User.find_by_name!("stanislaw").should be_kind_of(User)
    end
    
    pending "should not duplicate roles when adding" do
    
    end

    it "should all work" do
      admin_role = Role.find_by_name("admin")
      user = User.new(:name => "stanislaw")
      user.roles_list.should be_empty
      user.has_any_role?(:admin).should be_false
      user.roles << :admin
      user.db_roles.should include(admin_role)
      user.roles_list.should include(:admin)
      user.roles.should include(:admin)
      user.has_role?(:admin).should be_true
      user.admin?.should be_true
      user.is_admin?.should be_true
      user.has_roles?(:admin).should be_true
      user.save!
      user.db_roles.should include(admin_role)
      user.roles.should include(:admin)
      user = User.find_by_name! "stanislaw"
      user.roles.should include(:admin)
      user.roles.remove(:admin)
      user.roles.should be_empty
      user.save!
      user.roles.should be_empty
      user.roles = [:admin, :user]
      user.roles.should == Array.new([:admin, :user])
      user.has_role?(:admin, :user).should be_true
      user.has_roles?([:admin, :user]).should be_true
      user.db_roles.size.should == 2
      user.roles.clear!
      user.db_roles.should be_empty
      user.roles.should be_empty
      user.roles << :admin
      user.db_roles.should include(admin_role)
      user.roles.should include(:admin)
      user.add_role :user
      user.roles.should include(:user, :admin)
      user.has_any_role?(:user).should be_true
      user.has_any_role?(:user, :admin).should be_true
      user.has_any_role?([:user, :admin])
      user.has_any_role?(:blip).should be_false
    end
  end

end
