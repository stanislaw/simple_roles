$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

#require File.expand_path("../dummy/config/environment", __FILE__)
require 'require_all'

require 'active_record'
require 'active_model'

require 'simple_roles'
require_all File.expand_path("../fixtures/models", __FILE__)

require 'cutter'
require 'sugar-high/dsl'

require 'rspec/core'
#require 'shoulda'
require 'factory_girl'

require_all File.expand_path('../support', __FILE__)

#ActiveRecord::Base.logger = Logger.new(STDERR)

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.include Factory::Syntax::Methods

      path = File.dirname(__FILE__) + '/dummy/config/database.yml'
      dbfile = File.open(path)
      dbconfig = YAML::load(dbfile)
      puts "--------- #{dbconfig.inspect}"
      ActiveRecord::Base.establish_connection(dbconfig)

  config.before(:suite) do
    with ActiveRecord::Base.connection do
      ActiveRecord::Base.logger = Logger.new(STDERR)
      
      tables.map do |table|
        drop_table table
      end
    end

    with ActiveRecord::Migrator do
      migrate File.expand_path('../dummy/db/migrate', __FILE__)
    end

  end
end

