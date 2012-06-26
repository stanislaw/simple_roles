require 'spec_helper'

describe 'SimpleRoles Macros' do

  context "Macros availability" do
    subject { Module }
    before { require 'simple_roles' }
    specify { should be_kind_of SimpleRoles::Macros }
  end

  context "When Macros is applied" do
    subject { User }

    specify { should be_kind_of SimpleRoles::Macros }

    before do
      class User < ActiveRecord::Base
        simple_roles do
          strategy :many
        end
      end
    end

    context "Changes in User" do
      specify { should include SimpleRoles::Many::RolesMethods }
      specify { should include SimpleRoles::Many::RolesMethods }

      [:roles, :roles_list, :add_role, :roles=, :remove_role].each do |meth|
        specify { subject.new.should respond_to meth }
      end
    end

    context "Changes in SimpleRoles::Configuration" do
      it "should set strategy" do
        SimpleRoles::Configuration.strategy.should == :many
      end
    end
  end

end
