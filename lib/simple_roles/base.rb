module SimpleRoles
  module Base

    class << self
      def included base
        base.class_eval %{
          has_many :user_roles
          has_many :db_roles, :through => :user_roles, :class_name => 'Role', :source => :role
        }

        base.send :include, SimpleRoles::Base::InstanceMethods

        SimpleRoles::Configuration.user_models << base
        base.register_roles_methods
      end
    end

    module ClassMethods
      def register_roles_methods
        valid_roles.each do |role|
          class_eval %{
            def self.#{role}s
              Role.find_by_name("#{role}").users
            end
            
            def self.#{role}s_ids
              Role.find_by_name("#{role}").user_ids
            end
          }

          define_method :"#{role}?" do
            roles.include?(:"#{role}")
          end

          alias_method :"is_#{role}?", :"#{role}?"
        end
      end

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

      def add_roles *rolez
        roles_array.add *rolez
      end

      alias_method :add_role, :add_roles

      def remove_roles *rolez
        roles_array.remove *rolez
      end

      alias_method :remove_role, :remove_roles

      def roles= *rolez
        roles_array.roles = *rolez
      end

      private

      def roles_array
        @roles_array ||= SimpleRoles::RolesArray.new self
      end
    end

  end
end
