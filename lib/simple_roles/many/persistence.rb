module SimpleRoles
  module Many
    module Persistence
      class << self
        def included base
          base.class_eval %{ 
            has_many :user_roles
            has_many :roles, :through => :user_roles

            include Methods
          }
        end
      end

      module Methods
        def roles
          super.map(&:name).map(&:to_sym)
        end

        alias_method :roles_list, :roles

        def roles= *rolez
          rolez.to_symbols!.flatten!

          raise "Not a valid role!" if (rolez - SimpleRoles::Configuration.valid_roles).size > 0

          rolez = rolez.map do |rolle|
            begin
              Role.find_by_name!(rolle.to_s)
            rescue
              raise "Couldn't find Role for #{rolle}. Maybe you need to re-run migrations?"
            end
          end

          super rolez

          save!
        end
        
      end
    end
  end
end
