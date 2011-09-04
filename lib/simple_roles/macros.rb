module SimpleRoles
  module Macros
    def self.included(base)
    end

    def simple_roles &block
      yield SimpleRoles::Configuration if block
      include SimpleRoles::Base
    end
  end
end

Module.send :include, SimpleRoles::Macros
