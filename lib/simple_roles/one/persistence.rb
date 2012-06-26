module SimpleRoles
  module One
    module Persistence
      def role
        super.to_sym
      end

      def role= r
        super r.to_s
      end
    end
  end
end
