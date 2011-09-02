=begin
FactoryGirl.define do
  factory :first_message, :class => Carrier::Message do
    sender 1
    recipients [2, 3]
    content "Hello!"
    subject "FirstMessage"
    association :chain, :factory => :chain
  end

  factory :second_message, :class => Carrier::Message do
    sender 2
    recipients [3, 1]
    content "Hello you too!"
    subject "SecondMessage"
    association :chain, :factory => :chain
  end

  factory :chain, :class => Carrier::Chain do
  end
end
=end
