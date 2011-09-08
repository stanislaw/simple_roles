require 'spec_helper'


describe SimpleRoles::Base do

  context "Class Methods" do 
  
    subject { User }

    specify { should respond_to(:valid_roles) }
    its(:valid_roles) { should include(:user, :admin)}
  end

  context "Instance methods" do
    subject {User.new}
   
    [:db_roles, :user_roles].each do |meth|
      specify { should respond_to(meth) }
      its(:"#{meth}") { should be_empty }
    end

    [:roles, :roles_list, :role_groups_list].each do |meth|
      specify { should respond_to(meth) }
      its(:"#{meth}") { should be_empty }
    end

    context "Integration for roles methods" do
      it "should add :roles to accessible_attributes if they are Whitelisted" do
        user = User.new(:name => "stanislaw")
        user.roles << :admin
        user.roles_list.should include(:admin)
        user.save!
        User.find_by_name("stanislaw").should be_kind_of(User)
        User.delete_all

        User.attr_accessible :name
        
        user = User.new(:name => "stanislaw")
        user.roles << :admin
        user.roles_list.should include(:admin)
        user.save!
        User.find_by_name("stanislaw").should be_kind_of(User)
      end
      
      it "should all work" do
        admin_role = Role.find_by_name("admin")
        user = User.new(:name => "stanislaw")
        user.roles_list.should be_empty
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
        user.roles.should == []
        user.save!
        user.roles.should == []
        user.roles = [:admin, :user]
        user.roles.should == [:admin, :user]
        user.has_role?(:admin, :user).should be_true
        user.has_roles?([:admin, :user]).should be_true
        user.roles.clear
        user.roles.should be_empty
        user.roles << :admin
        user.db_roles.should include(admin_role)
        user.roles.should include(:admin)
        user.add_role :user
        user.roles.should include(:user, :admin)
      end
    end
  end

end
