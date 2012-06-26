require "sweetloader"
require "require_all"

require "sugar-high/array"
require "sugar-high/dsl"

require "simple_roles/engine" if defined?(Rails)
require "simple_roles/macros"

require_all File.expand_path("../../app", __FILE__)

module SimpleRoles
  autoload_modules :One, :Many
  autoload_modules :Base, :Configuration, :RolesArray

  extend self

  def configure &block
    yield config
  end

  def config
    SimpleRoles::Configuration
  end
  delegate :strategy_class, :to => :config, :prefix => false

  delegate :package, :to => :strategy_class, :prefix => false
end
