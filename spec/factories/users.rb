FactoryBot.define do
  factory :user do
    id { rand(10**18) }
    discord_id { id.to_s }
    sequence(:name, 'テスト1')
    sequence(:email, 'test@example.com')
    after(:build) do |user|
      create(:authentication, user: user)
    end
  end

  trait :with_guild do
    transient do
      sequence(:guild_name) {|n| "ギルドテスト_#{n}"}
    end
    after(:create) do |user, evaluator|
      user.guilds << create(:guild, id: rand(10**18), name: evaluator.guild_name )
    end
  end

  trait :with_channel do
    transient do
      sequence(:position) {|n| 1}
      sequence(:channel_name) {|n| "チャンネルテスト_#{n}"}
    end
    after(:create) do |user, evaluator|
      user.channels << create(:channel, id: rand(10**18), position: evaluator.position, name: evaluator.channel_name, guild_id: Guild.first.id)
    end
  end
end