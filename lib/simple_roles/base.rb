module SimpleRoles
  module Base

    def self.included base
      base.class_eval %{
        has_many :user_roles
        has_many :db_roles, :through => :user_roles, :class_name => 'Role', :source => :role
      }

      base.send :include, SimpleRoles::Base::InstanceMethods
    end

    module ClassMethods
      def valid_roles
        SimpleRoles::Configuration.valid_roles
      end
    end

    module InstanceMethods

      def self.included base
        base.send :extend, ClassMethods
      end

      #SimpleRoles::Configuration.valid_roles.each do |role|
      #  define_method :"#{role}?" do
      #    roles.include?(:"#{role}")
      #  end
      #end

      def roles
        roles_array 
      end

      alias_method :roles_list, :roles

      def has_roles? *rolez
        rolez.flatten!
        rolez.each do |role|
          return false if !roles.include? role
        end
        true
      end

      alias_method :has_role?, :has_roles?

      def add_role *rolez
        roles_array.add *rolez
      end

      def roles= *rolez
        roles_array.roles = *rolez
      end

      # TODO: implement
      #
      def role_groups_list
        []
      end

      private

      def roles_array
        @roles_array ||= RolesArray.new self
      end

    end

    class RolesArray < Array

      attr_reader :base, :roles

      def initialize base
        @base = base
        synchronize
      end

      def synchronize
        replace real_roles
      end

      def roles
        self
      end

      def real_roles_db
        base.db_roles
      end

      def real_roles
        real_roles_db.map(&:name).map(&:to_sym)
      end

      def roles= *r
        r.flatten!.to_symbols_uniq!
        raise "Not a valid role!" if (r - SimpleRoles::Configuration.valid_roles).size > 0
        a = (r - roles)
        base.db_roles = a.map do |rolle|
          Role.find_by_name(rolle.to_s)
        end
        base.save!
        synchronize
      end

      def << *args
        self.roles = roles | args
      end

      alias_method :add, :<<

      def remove *role
        self.roles = roles - role
      end

      def clear
        real_roles_db.clear 
        synchronize
      end
    end
  end
end
