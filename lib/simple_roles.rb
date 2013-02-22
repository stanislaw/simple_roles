require 'active_record'

require 'simple_roles/version'

require 'simple_roles/macros'

Dir[File.expand_path('../../app/models/*', __FILE__)].each do |f|
  require f
end

module SimpleRoles
  autoload :Configuration, 'simple_roles/configuration'
  autoload :Packager, 'simple_roles/packager'
  autoload :One, 'simple_roles/one'
  autoload :Many, 'simple_roles/many'

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
