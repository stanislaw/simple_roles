module SimpleRoles
  module Packager 
    extend self

    def package clazz, strategy = config.strategy
      SimpleRoles::Configuration.user_models << clazz

      clazz.send :include, SimpleRoles::config.strategy_class(strategy)::Persistence
      clazz.send :include, SimpleRoles::config.strategy_class(strategy)::RolesMethods
    end

    private

    def config
      SimpleRoles.config
    end
  end
end
