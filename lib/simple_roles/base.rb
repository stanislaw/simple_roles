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

      def mass_assignment_authorizer *args
        super.empty? ? super : (super + [:roles])
      end
      
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

      def has_any_role? *rolez
        rolez.flatten!
        rolez.each do |role|
          return true if roles.include? role
        end
        false 
      end

      SimpleRoles::Configuration.valid_roles.each do |role|
        define_method :"#{role}?" do
          roles.include?(:"#{role}")
        end

        alias_method :"is_#{role}?", :"#{role}?"
      end


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

      attr_reader :base

      def initialize base
        @base = base
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
        rolez.flatten!.to_symbols_uniq!
        raise "Not a valid role!" if (rolez - SimpleRoles::Configuration.valid_roles).size > 0
        base.db_roles = rolez.map do |rolle|
          begin
            Role.find_by_name!(rolle.to_s)
          rescue
            raise "Couldn't find Role for #{rolle}. Maybe you need to re-run migrations?"
          end
        end
        synchronize
      end

      def << *args
        self.roles = self | args
      end

      alias_method :add, :<<

      def remove *role
        self.roles = self - role
      end

      def clear
        real_roles_db.clear 
        synchronize
      end
    end
  end
end
