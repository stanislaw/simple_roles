module SimpleRoles
  module Many
    module Persistence
      class << self
        def included base
          base.class_eval %{
            has_many :user_roles
            has_many :db_roles, :through    => :user_roles,
                                :class_name => 'Role',
                                :source     => :role
          }
        end
      end
    end
  end
end
