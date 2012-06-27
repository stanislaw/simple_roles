# SimpleRoles

SimpleRoles is a Rails Engine providing simple Role System for any Rails 3 app. It was created as demo role-system to accompany [CanTango gem](https://github.com/kristianmandrup/cantango) initial installiation and usage. Intended to be very easy to setup & use.

It even seems to be good for being used as a real role system inspite of (or due to ;)) its almost maximum simplicity.

If you are looking for a real serious roles system solution try [Troles](https://github.com/kristianmandrup/troles) gem created by [Kristian Mandrup](https://github.com/kristianmandrup)

## Installiation

### Prerequisites

SimpleRoles requires you have have User model in your Rails app. That's all.

### It is a Gem

include in Gemfile:

```ruby
gem 'simple_roles' 
```

### Set up valid roles you're gonna have in your app and choose a Strategy. 

Create file simple_roles.rb in config/initializers and write there:

```ruby
# config/initializers/simple_roles.rb
SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
  config.strategy = :many # Default is :one
end
```

or in a nicer way:

```ruby
# config/initializers/simple_roles.rb
SimpleRoles.configure do
  valid_roles :user, :admin, :editor
  strategy :many # Default is :one
end
```

Now it is time to choose beetween two strategies possible:

* One - each of your users has only one role. It is the most common
  choise for the most of the apps.
* Many - your user can be _:editor_ and _:curator_ and _:instructor_ all
  at the same time. More rare one, setup is slightly more complex.

### One Strategy

One strategy assumes your User model has string-typed 'role' column. Add this to your migrations and run them:

```ruby
class CreateUsers < ActiveRecord::Migration
  def up
    create_table(:users) do |t|
      # ...
      t.string :role
      # ... 
    end
  end

  def down
    drop_table :users
  end
end
```

Finally, include 'simple_roles' macros in your User model:

```ruby
class User
  simple_roles
end
```

### Many strategy

In its background 'Many' strategy has following setup, based on <i>has_many :through</i> relations:

```ruby
class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, :through => :user_roles
end
  
class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end

class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, :through => :user_roles
end
```

**You don't need to create these classes (UserRoles, Roles) and write these associations by hands** - all these classes SimpleRoles configures **automatically**. The only class you need is User and you must have *simple_roles* in it (see below).

**But you need** to supply migrations for them - copy and migrate SimpleRoles migrations by following rake task:

```ruby
rake simple_roles_engine:install:migrations
rake db:migrate
```

**Note!** Migrations are based on roles you are to set up as valid (see previous step). If you do not create initializer with valid_roles, then valid_roles will be set up to defaults: :user and :admin.

And finally include 'simple_roles' macros in your User model:

```ruby
class User
  simple_roles
end
```

### Notes

You can skip configuration in initializers and write it the following
way:

```ruby
class User
  simple_roles do
    strategy :one
    valid_roles :user, :editor
  end
end
```

## Usage example

```ruby
user = User.new
user.roles # => []

user.roles = :admin
user.roles # => [:admin]
user.roles_list # => [:admin]

user.admin? # => true
user.is_admin? # => true

user.roles = [:admin, :user]
user.roles # => [:admin, :user]
user.is_user? # => true

user.add_role :editor
user.roles # => [:admin, :user, :editor]

user.remove_role :user
user.roles # => [:admin, :editor]
user.has_role?(:admin) # => true
user.has_any_role?(:admin, :blip) # => true
user.has_role?(:blogger) # => false
```

## Copyright

Copyright (c) 2012 Stanislaw Pankevich.
