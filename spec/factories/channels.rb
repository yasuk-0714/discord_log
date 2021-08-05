FactoryBot.define do
  factory :channel do
    id { rand(10**18) }
    sequence(:name, 'test_channel_1')
    sequence(:position, 1)
    guild
  end
end