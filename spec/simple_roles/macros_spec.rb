require 'spec_helper'

describe SimpleRoles::Base do
  
  context "Macros availability" do
    subject { Module }
    before {
      require 'simple_roles'
    }

    specify { should be_kind_of(SimpleRoles::Macros) }
  end

  context "after applying macros" do
    subject { User }
    before do
      class User < ActiveRecord::Base
        simple_roles
      end
    end

    specify { should be_kind_of(SimpleRoles::Macros) }    
  end

end
