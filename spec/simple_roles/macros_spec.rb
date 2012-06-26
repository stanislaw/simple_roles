require 'spec_helper'

describe 'SimpleRoles Macros' do
  
  context "Macros availability" do
    subject { Module }
    before { require 'simple_roles' }
    specify { should be_kind_of(SimpleRoles::Macros) }
  end

  context "When Macros is being applied" do
    subject { User }

    before do
      class User < ActiveRecord::Base
        simple_roles do
          strategy :many
        end
      end
    end

    specify { should be_kind_of(SimpleRoles::Macros) }
   
    context "Changes in User" do

    end
    
    context "Changes in SimpleRoles::Configuration" do
      it "should set strategy" do
        SimpleRoles::Configuration.strategy.should == :many
      end
    end
  end

end
