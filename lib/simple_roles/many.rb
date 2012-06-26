module SimpleRoles
  module Many
    extend self

    autoload_modules :Persistence, :RolesMethods, :RolesArray

    def package clazz
      SimpleRoles::Configuration.user_models << clazz

      clazz.send :include, SimpleRoles::Many::Persistence
      clazz.send :include, SimpleRoles::Many::RolesMethods
    end
  end
end
