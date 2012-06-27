require 'sweetloader'
require 'require_all'

require 'sugar-high/array'
require 'sugar-high/dsl'

require 'active_record'

require 'simple_roles/version'

require 'simple_roles/engine' if defined?(Rails)
require 'simple_roles/macros'

require_all File.expand_path('../../app', __FILE__)

module SimpleRoles
  autoload_modules :Configuration, :Packager, :One, :Many

  extend self

  def configure &block
    config.instance_exec config, &block
  end

  def config
    SimpleRoles::Configuration
  end

  def packager
    SimpleRoles::Packager
  end
  
  delegate :package, :to => :packager, :prefix => false
end
