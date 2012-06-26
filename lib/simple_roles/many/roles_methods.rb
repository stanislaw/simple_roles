module SimpleRoles
  module Many
    module RolesMethods
      class << self
        def included base
          SimpleRoles::Configuration.user_models << base
          base.send :extend, SimpleRoles::Many::RolesMethods::DynamicMethods
        end
      end

      module DynamicMethods
        class << self
          def extended base
            base.register_dynamic_methods
          end
        end

        def register_dynamic_methods
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

      def mass_assignment_authorizer *args
        super.empty? ? super : (super + [:roles])
      end

      def roles
        roles_array 
      end

      alias_method :roles_list, :roles

      def has_roles? *rolez
        rolez.flatten!

        rolez.all? do |role|
          roles.include? role
        end
      end

      alias_method :has_role?, :has_roles?

      def has_any_role? *rolez
        rolez.flatten!

        rolez.any? do |role|
          roles.include? role
        end
      end

      def add_roles *rolez
        roles_array.add *rolez
      end

      alias_method :add_role, :add_roles

      def remove_roles *rolez
        roles_array.remove *rolez
      end

      alias_method :remove_role, :remove_roles

      def set_role r
        self.roles = r
      end

      def roles= *rolez
        roles_array.roles = *rolez
      end

      private

      def roles_array
        @roles_array ||= SimpleRoles::Many::RolesArray.new self
      end
    end
  end
end
