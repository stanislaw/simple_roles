class User < ActiveRecord::Base
  

  simple_roles

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # DEVISE
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # OTHER
  attr_accessible :name, :username
end
