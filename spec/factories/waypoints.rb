FactoryBot.define do
  factory :waypoint do
    flight { nil }
    number { 1 }
    name { "MyString" }
    position { "MyString" }
    altitude { "MyString" }
  end
end
