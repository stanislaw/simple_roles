require 'spec_helper'

SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
end

describe 'Integration for SimpleRoles::Many' do
  before do
    setup_roles
    SimpleRoles::Packager.package User, :many
  end

  it "should all work" do
    admin_role = Role.find_by_name("admin")
    user = User.new(:name => "stanislaw")
    user.roles_list.should be_empty
    user.has_any_role?(:admin).should be_false
    user.roles = [ :admin ]
    user.roles_list.should include(:admin)
    user.roles.should include(:admin)
    user.has_role?(:admin).should be_true
    user.admin?.should be_true
    user.is_admin?.should be_true
    user.has_roles?(:admin).should be_true
    user.save!
    user.roles.should include(:admin)
    user = User.find_by_name! "stanislaw"
    user.roles.should include(:admin)
    user.remove_role(:admin)
    user.roles.should be_empty
    user.save!
    user.roles.should be_empty
    user.roles = [:admin, :user]
    user.roles.should == Array.new([:admin, :user])
    user.has_role?(:admin, :user).should be_true
    user.has_roles?([:admin, :user]).should be_true
    user.roles.size.should == 2
    user.roles = [:admin]
    user.roles.should include(:admin)
    user.add_role :user
    user.roles.should include(:user, :admin)
    user.has_any_role?(:user).should be_true
    user.has_any_role?(:user, :admin).should be_true
    user.has_any_role?([:user, :admin])
    user.has_any_role?(:blip).should be_false
  end
end
