require 'singleton'
module SimpleRoles
  module Configuration

    class << self
      attr_accessor :valid_roles
 
      def valid_roles= vr
        raise if !vr.kind_of?(Array)
        @valid_roles = vr
      end

      def valid_roles
        @valid_roles || default_roles
      end

      def default_roles
        [:user, :admin]
      end
    end
  end
end
