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
      alias_method :update_role, :set_role

      def has_role? r
        role == r
      end

      def has_any_role? *rolez
        rolez.flatten!

        rolez.any? do |r|
          has_role? r
        end
      end
      
      module DynamicMethods
        class << self
          def extended base
            base.register_dynamic_methods
          end
        end

        def register_dynamic_methods
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
