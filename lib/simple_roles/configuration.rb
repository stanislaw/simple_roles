require 'singleton'
module SimpleRoles
  module Configuration

    class << self
      attr_accessor :valid_roles
 
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
        SimpleRoles::Base.class_eval do
          SimpleRoles::Configuration.valid_roles.each do |role|
            define_method :"#{role}?" do
              roles.include?(:"#{role}")
            end
            alias_method :"is_#{role}?", :"#{role}?"
          end
        end
      end
    end
  end
end
