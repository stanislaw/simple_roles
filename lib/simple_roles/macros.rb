module SimpleRoles
  module Macros
    def simple_roles &block
      yield SimpleRoles.config if block
      include SimpleRoles::Base
    end
  end
end

Module.send :include, SimpleRoles::Macros
