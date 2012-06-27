require 'spec_helper'

SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
end

describe 'Integration for SimpleRoles::One' do
  before do
    setup_roles
    SimpleRoles::Packager.package OneUser, :one
  end

  it "should all work" do
    user = create :one_user, :role => nil
    user.role.should be_nil

    user.role = :admin
    user.role.should == :admin
    user.admin?.should be_true
    user.is_admin?.should be_true

    user.role = 'admin' # Accepts strings too
    user.role.should == :admin

    user.set_role(:editor)
    user.role.should == :editor

    user.update_role(:user)
    user.role.should == :user

    user.user?.should be_true
    user.is_user?.should be_true

    user.admin?.should be_false
    user.is_admin?.should be_false
  end
end
