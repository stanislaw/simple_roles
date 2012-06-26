SimpleRoles.configure do |config|
  config.strategy :many
  config.valid_roles = [:user, :admin, :editor]
end
