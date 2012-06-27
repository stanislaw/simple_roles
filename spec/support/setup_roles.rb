def setup_roles
  SimpleRoles::Configuration.valid_roles.each do |role|
    Role.create(:name => role.to_s) if Role.where(:name => role.to_s).empty?
  end
end
