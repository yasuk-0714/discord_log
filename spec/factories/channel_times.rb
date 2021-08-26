FactoryBot.define do
  factory :channel_time do
    start_time { Time.now }
    end_time { 1.hours.ago }
    total_time { Time.now - 1.hours.ago}
    user_channel
  end
end