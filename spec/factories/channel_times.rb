FactoryBot.define do
  factory :channel_time do
    user_channel
  end

  trait :today_time do
    start_time { Time.now }
    end_time { 1.hours.ago }
    total_time { TIme.now - 1.hours.ago}
  end
end