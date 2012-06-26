require 'spec_helper'

describe SimpleRoles::Configuration do
  subject { SimpleRoles::Configuration }

  its(:default_strategy) { should == :one }
  its(:strategy) { should == :one }
  its(:strategy_class) { should == SimpleRoles::One }

  describe ".strategy" do
    it "should retrieve current strategy if no argument passed" do
      subject.strategy.should == :one
    end

    it "should set current strategy if strategy passed as argument" do
      subject.strategy :many
      subject.strategy.should == :many
    end
    
    it "should not allow wrong strategies" do
      expect {
        subject.strategy :wrong!
      }.to raise_error
    end
  end

  describe ".strategy=" do
    it "should set current strategy if strategy passed as argument" do
      subject.strategy = :one
      subject.strategy.should == :one

      subject.strategy = :many
      subject.strategy.should == :many
    end

    it "should not allow wrong strategies" do
      expect {
        subject.strategy = :wrong!
      }.to raise_error
    end
  end
 
  describe ".valid_roles=" do
    it "should set valid roles" do
      valid_roles_before = SimpleRoles::Configuration.valid_roles

      SimpleRoles::Configuration.valid_roles = [:user]
      SimpleRoles::Configuration.valid_roles.should == [:user]

      SimpleRoles::Configuration.valid_roles = valid_roles_before
      SimpleRoles::Configuration.valid_roles.should == valid_roles_before
    end
  end

  describe ".valid_roles" do
    it "should also set valid roles if they passed as arg" do
      valid_roles_before = SimpleRoles::Configuration.valid_roles

      SimpleRoles::Configuration.valid_roles :user
      SimpleRoles::Configuration.valid_roles.should == [:user]

      SimpleRoles::Configuration.valid_roles valid_roles_before
      SimpleRoles::Configuration.valid_roles.should == valid_roles_before
    end
  end
end
