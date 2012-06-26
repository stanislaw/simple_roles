module SimpleRoles
  module Many
    class RolesArray < Array

      attr_reader :base

      def initialize *args
        @base = args.delete(args.first)
        super
        synchronize
      end

      def synchronize 
        replace real_roles
      end
      
      def real_roles_db
        base.db_roles
      end

      def real_roles
        real_roles_db.map(&:name).map(&:to_sym)
      end

      def clear!
        real_roles_db.clear
        base.save!
        clear
      end
    end
  end
end
