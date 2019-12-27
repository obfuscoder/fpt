FactoryBot.define do
  factory :flight do
    theater { "MyString" }
    airframe { "MyString" }
    start { "2019-12-24 01:57:03" }
    duration { 1 }
    callsign { "MyString" }
    callsign_number { 1 }
    slots { 1 }
    mission { "MyString" }
    task { "MyString" }
    group_id { 1 }
    laser { 1 }
    tacan_channel { 1 }
    tacan_polarization { "MyString" }
    frequency { "9.99" }
    notes { "MyText" }
  end
end
