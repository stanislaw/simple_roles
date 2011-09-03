require 'spec_helper'

describe SimpleRoles::Base do
  before do
    class User < ActiveRecord::Base
      simple_roles
    end
  end

  context "Class Methods" do 
    subject {User}
  
  end

  context "Instance methods" do
    subject {User.new}

    specify {}
  end

end
