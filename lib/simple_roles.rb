require "sweetloader"
require "require_all"

require "simple_roles/engine" if defined?(Rails)
require "simple_roles/macros"

require_all File.expand_path("../../app", __FILE__)

module SimpleRoles
  autoload_modules :Base, :Configuration

  class << self
    def configure &block
      yield SimpleRoles::Configuration
    end
  end
end
