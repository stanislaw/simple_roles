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

      def roles= *rolez
        rolez.to_symbols!.flatten!
        raise "Not a valid role!" if (rolez.to_a - SimpleRoles::Configuration.valid_roles).size > 0

        base.db_roles = rolez.map do |rolle|
          begin
            Role.find_by_name!(rolle.to_s)
          rescue
            raise "Couldn't find Role for #{rolle}. Maybe you need to re-run migrations?"
          end
        end

        synchronize
      end

      def << *rolez
        rolez.flatten!
        self.roles = self.to_a + rolez
      end

      alias_method :add, :<<

      def remove *rolez
        rolez.flatten!
        self.roles = self.to_a - rolez
      end

      def clear!
        real_roles_db.clear
        base.save!
        clear
      end
    end
  end
end
