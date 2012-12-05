
FactoryGirl.define do
  factory :longdrink, :class => Refinery::Longdrinks::Longdrink do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

