FactoryBot.define do
  factory :guild do
    id { rand(10**18) }
    sequence(:name, 'test_guild_1')
  end

  trait :with_user do
    transient do
      sequence(:user_name) {|n| "ギルドテスト_#{n}"}
    end
    after(:create) do |user, evaluator|
      user.guilds << create(:guild, id: rand(10**18), name: evaluator.guild_name )
    end
  end
end