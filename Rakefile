#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'simple_roles'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "simple_roles"
  gem.homepage = "http://github.com/stanislaw/simple_roles"
  gem.license = "MIT"
  gem.summary = %Q{Rails Engine providing Role System for Rails apps}
  gem.description = %Q{Simple Role System for Rails Apps}
  gem.email = "s.pankevich@gmail.com"
  gem.authors = ["stanislaw"]
  gem.version = SimpleRoles::VERSION
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleRoles'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
