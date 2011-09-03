require "simple_roles/engine" if defined?(Rails)
require "simple_roles/macros"

require "sweetloader"
module SimpleRoles
  autoload_modules :Base, :Configuration
end
