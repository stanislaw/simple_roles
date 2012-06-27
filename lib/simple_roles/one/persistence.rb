module SimpleRoles
  module One
    module Persistence
      def role
        (r = super) ? r.to_sym : nil
      end

      def role= r
        check_role r
        r ? super(r.to_s) : super(nil)
      end

      private

      def check_role role
        return unless role

        valid_roles = SimpleRoles.config.valid_roles

        raise "Not a valid role! Try on of: #{valid_roles.join(', ')}" if ([role.to_sym] - valid_roles).size > 0
      end
    end
  end
end
