module SimpleRoles
  module Base

    def self.included base
      base.class_eval %{
        has_many :user_roles
        has_many :db_roles, :through => :user_roles, :class_name => 'Role', :source => :role
      }
    end

    SimpleRoles::Configuration.valid_roles.each do |role|
      Role.create(:name => role.to_s)

      define_method :"#{role}?" do
        roles.include?(:"#{role}")
      end
    end

    def roles
      db_roles.map(&:name).map(&:to_sym)
    end

    alias_method :roles_list, :roles

    def roles= *r
      raise "Not a valid role!" if (r - SimpleRoles::Configuration.valid_roles).size > 0
      a = (r - roles)
      a.each do |rolle|
        db_roles << Role.find_by_name(rolle.to_s)
      end
      save!
    end
  
    def role_groups_list
      role_groups
    end

    private

  end
end
