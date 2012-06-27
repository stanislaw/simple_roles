SimpleRoles.configure do |config|
  strategy :one
  valid_roles :user, :admin, :editor
end
