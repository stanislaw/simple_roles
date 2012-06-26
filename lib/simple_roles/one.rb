module SimpleRoles
  module One
    extend self

    autoload_modules :Persistence, :RolesMethods

    def package clazz
      SimpleRoles::Configuration.user_models << clazz
      clazz.send :include, SimpleRoles::One::RolesMethods
    end
  end
end
