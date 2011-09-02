$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require 'require_all'
require 'rspec/rails'
require 'cutter'
require 'capybara/rails'
require 'capybara/rspec'
#require 'shoulda'
require 'factory_girl'
require 'sugar-high/dsl'
require_all File.expand_path('../support', __FILE__)

#ActiveRecord::Base.logger = Logger.new(STDERR)

RSpec.configure do |config|
  config.include Warden::Test::Helpers, :type => :request
  config.after(:each, :type => :request) {Warden.test_reset!}

  config.mock_with :rspec
  
  config.include Factory::Syntax::Methods

  config.before(:suite) do
    with ActiveRecord::Base.connection do
      tables.map do |table|
        drop_table table
      end
    end

    with ActiveRecord::Migrator do
      migrate File.expand_path('../dummy/db/migrate', __FILE__)
    end

    require "dummy/db/seeds"
  end
end

