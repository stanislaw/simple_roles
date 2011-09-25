# SimpleRoles

SimpleRoles is a Rails Engine providing simple Role System for any Rails 3 app. It was created as demo role-system to accompany [CanTango gem](https://github.com/kristianmandrup/cantango) initial installiation and usage. Intended to be very easy to setup & use.

It even seems to be good for being used as a real role system inspite of (or due to ;)) its almost maximum simplicity.

If you are looking for a real serious roles system solution try [Troles](https://github.com/kristianmandrup/troles) gem created by [Kristian Mandrup](https://github.com/kristianmandrup)

## Installiation

### Prerequisites

SimpleRoles only assumes you have User model

### Not a Gem yet

include in Gemfile:

```ruby
gem 'simple_roles', :git => "git://github.com/stanislaw/simple_roles.git"
bundle update
```

### Set up valid roles you're gonna have in your app

Create file simple_roles.rb in config/initializers and write there:

```ruby
# config/initializers/simple_roles.rb
SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
end
```

### Copy and migrate SimpleRoles migrations by following rake task:

```ruby
rake simple_roles_engine:install:migrations
rake db:migrate
```

Note! Migrations are based on roles you set up as valid (see previous step). If you do not create initializer with valid_roles, then valid_roles will be set up to defaults: :user and :admin.

### And finally include 'simple_roles' macros in your User model:

```ruby
class User
  simple_roles
end
```

## Usage

```ruby
user.roles => #<RolesArray: {}>

user.roles = :admin
user.roles # => #<RolesArray: {:admin}>
user.roles_list # => #<RolesArray: {:admin}>
user.admin? # => true
user.is_admin? # => true

user.roles << :user
user.roles # => #<RolesArray: {:admin, :user}>
user.is_user? # => true

user.add_role :editor
user.roles # => #<RolesArray: #{:admin, :user, :editor}>

user.remove_role :user
user.roles # => #<RolesArray: {:admin, :editor}>
user.has_role?(:admin) # => true
user.has_any_role?(:admin, :blip) # => true
user.has_role?(:blogger) # => false
```

## Todo:

- Write role groups part
- Provide some more config options
- More and better tests
