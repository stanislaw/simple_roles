module SimpleRoles
  module Macros
    def simple_roles &block
      SimpleRoles.config.instance_exec(SimpleRoles.config, &block) if block
      SimpleRoles.package self
    end
  end
end

Module.send :include, SimpleRoles::Macros
