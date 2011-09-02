class User < ActiveRecord::Base
  serialize :roles

  has_many :user_roles
  has_many :roles, :through => :user_roles
end
