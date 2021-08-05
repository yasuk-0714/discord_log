FactoryBot.define do
  factory :authentication do
    uid { rand(10**18).to_s }
    provider { 'discord' }
    access_token { rand(10**18).to_s }
    refresh_token { rand(10**18).to_s }
    user
  end
end