$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

#require File.expand_path("../dummy/config/environment", __FILE__)
require 'require_all'

#require 'rails'
require 'active_record'
require 'active_model'

require 'simple_roles'

require 'cutter'
require 'sugar-high/dsl'

require 'rspec/core'
#require 'shoulda'
require 'factory_girl'

require_all File.expand_path('../support', __FILE__)

path = File.dirname(__FILE__) + '/support/database.yml'
dbfile = File.open(path)
dbconfig = YAML::load(dbfile)
ActiveRecord::Base.establish_connection(dbconfig)

#ActiveRecord::Base.logger = Logger.new(STDERR)

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.include Factory::Syntax::Methods

  config.before(:suite) do
    with ActiveRecord::Base.connection do
      
      tables.map do |table|
        drop_table table
      end
    end

    with ActiveRecord::Migrator do
      # SimpleRoles's own migrations
      ActiveRecord::Migrator.migrate File.expand_path('../../db/migrate', __FILE__)
      # Helper migration - users table
      ActiveRecord::Migrator.migrate File.expand_path('../support/migrations', __FILE__)
    end

  end
end
