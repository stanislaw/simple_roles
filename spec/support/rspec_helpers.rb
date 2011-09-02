
module RSpec
  module Core
    class ExampleGroup

      class << self
        alias_method :concern, :describe if instance_methods.include?(:describe)

        def register_concern
          alias_method :concern, :describe if instance_methods.include?(:describe)
        end

        def singleton_method_added name
          class << self
            undef_method :register_concern
          end if name == :describe
        end

      end
    end
  end
end
