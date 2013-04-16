$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

#require File.expand_path("../dummy/config/environment", __FILE__)

require 'logger'
require 'require_all'
require 'cutter'
require 'sugar-high/dsl'

require 'active_record'
require 'database_cleaner'

require 'rspec/core'

require 'factory_girl'

require 'simple_roles'

require_all File.expand_path('../support', __FILE__)

path = File.dirname(__FILE__) + '/support/database.yml'

dbfile = File.open(path)
dbconfig = YAML::load(dbfile)
ActiveRecord::Base.establish_connection(dbconfig)

# class ActiveRecord::Base
  # mattr_accessor :shared_connection
  # @@shared_connection = nil

  # def self.connection
    # @@shared_connection || retrieve_connection
  # end
# end

#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

# ActiveRecord::Base.logger = Logger.new(STDERR)

# TODO: do not preserve roles table
DatabaseCleaner.strategy = :truncation, { :except => %w[roles], :pre_count => true, :reset_ids => true }

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
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
