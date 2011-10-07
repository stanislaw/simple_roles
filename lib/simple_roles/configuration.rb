require 'singleton'
module SimpleRoles
  module Configuration

    extend self
    
    attr_accessor :valid_roles, :user_models

    def user_models
      @user_models ||= []
    end

    def valid_roles= vr
      raise "There should be an array of valid roles" if !vr.kind_of?(Array)
      @valid_roles = vr
      distribute_methods
    end

    def valid_roles
      @valid_roles || default_roles
    end

    def default_roles
      [:user, :admin]
    end

    def distribute_methods
      user_models.each do |um|
        um.register_roles_methods
      end
    end
  end
end
