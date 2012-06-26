SimpleRoles.configure do |config|
  strategy :many
  valid_roles :user, :admin, :editor
end
