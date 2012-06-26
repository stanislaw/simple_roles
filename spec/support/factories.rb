
FactoryGirl.define do
  factory :user, :class => User do
    name 'stanislaw'
  end

  factory :one_user, :class => OneUser do
    name 'stanislaw'
    role = 'user'
  end
end
