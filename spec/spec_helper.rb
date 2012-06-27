$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

#require File.expand_path("../dummy/config/environment", __FILE__)
require 'logger'
require 'require_all'
require 'cutter'
require 'sugar-high/dsl'

require 'active_record'

require 'rspec/core'

require 'factory_girl'

require 'simple_roles'

require_all File.expand_path('../support', __FILE__)

path = File.dirname(__FILE__) + '/support/database.yml'

dbfile = File.open(path)
dbconfig = YAML::load(dbfile)
ActiveRecord::Base.establish_connection(dbconfig)

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

# ActiveRecord::Base.logger = Logger.new(STDERR)

RSpec.configure do |config|
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    with ActiveRecord::Base.connection do
      # tables.each {|t| drop_table t }

      with ActiveRecord::Migrator do
        # SimpleRoles's own migrations
        migrate File.expand_path('../../db/migrate', __FILE__)
        # Helper migration - users table
        migrate File.expand_path('../support/migrations', __FILE__)
      end if tables.empty?

      # (tables - ['schema_migrations']).map do |table|
      #   table_count = execute("SELECT COUNT(*) FROM #{table}").first.first
      #   execute "TRUNCATE #{table}" unless table_count == 0
      # end
    end
  end

  config.before(:each) do
    Transaction.start
  end

  config.after(:each) do
    Transaction.clean
  end
end
