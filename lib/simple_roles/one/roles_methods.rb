module SimpleRoles
  module One
    module RolesMethods
      include SimpleRoles::One::Persistence

      class << self
        def included base
          base.extend DynamicMethods
        end
      end

      def set_role r
        self.role= r
        save!
      end

      module DynamicMethods
        class << self
          def extended base
            base.register_roles_methods
          end
        end

        def register_roles_methods
          SimpleRoles.config.valid_roles.each do |r|
            scope :"#{r}s", where(:role => r.to_s)
            
            define_method :"#{r}?" do
              role == r
            end

            alias_method :"is_#{r}?", :"#{r}?"
          end
        end
      end
    end
  end
end
