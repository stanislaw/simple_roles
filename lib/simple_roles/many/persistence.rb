module SimpleRoles
  module Many
    module Persistence
      class << self
        def included base
          base.class_eval %{ 
            has_many :user_roles
            has_many :roles, :through => :user_roles
          }
        end
      end

      def roles
        super.map(&:name).map(&:to_sym)
      end

      def roles= *rolez
        rolez.to_symbols!.flatten!

        super retrieve_roles(rolez)

        save!
      end

      private

      def retrieve_roles rolez
        raise "Not a valid role!" if (rolez - config.valid_roles).size > 0

        rolez.map do |rolle|
          begin
            Role.find_by_name! rolle.to_s
          rescue
            raise "Couldn't find Role for #{rolle}. Maybe you need to re-run migrations?"
          end
        end
      end

      def config
        SimpleRoles::Configuration
      end
    end
  end
end
