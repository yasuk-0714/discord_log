#今日
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: Time.now.beginning_of_day,
    end_time: Time.now.beginning_of_day + 30.minutes,
    total_time: Time.now.beginning_of_day + 30.minutes - Time.now.beginning_of_day,
    created_at: Time.now.beginning_of_day
  )
end
#昨日
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: Time.now.yesterday.beginning_of_day,
    end_time: Time.now.yesterday.beginning_of_day + 2.hours,
    total_time: Time.now.yesterday.beginning_of_day + 2.hours - Time.now.yesterday.beginning_of_day,
    created_at: Time.now.yesterday.beginning_of_day
  )
end
#２日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 2.days.ago.beginning_of_day,
    end_time: 2.days.ago.beginning_of_day + 1.hours + 30.minutes,
    total_time: 2.days.ago.beginning_of_day + 1.hours + 30.minutes - 2.days.ago.beginning_of_day,
    created_at: 2.days.ago.beginning_of_day
  )
end
#３日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 3.days.ago.beginning_of_day,
    end_time: 3.days.ago.beginning_of_day + 1.hours + 45.minutes,
    total_time: 3.days.ago.beginning_of_day + 1.hours + 45.minutes - 3.days.ago.beginning_of_day,
    created_at: 3.days.ago.beginning_of_day
  )
end
#４日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 4.days.ago.beginning_of_day,
    end_time: 4.days.ago.beginning_of_day + 1.hours + 30.minutes,
    total_time: 4.days.ago.beginning_of_day + 1.hours + 30.minutes - 4.days.ago.beginning_of_day,
    created_at: 4.days.ago.beginning_of_day
  )
end
#５日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 5.days.ago.beginning_of_day,
    end_time: 5.days.ago.beginning_of_day + 20.minutes,
    total_time: 5.days.ago.beginning_of_day + 20.minutes - 5.days.ago.beginning_of_day,
    created_at: 5.days.ago.beginning_of_day
  )
end
#６日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 6.days.ago.beginning_of_day,
    end_time: 6.days.ago.beginning_of_day + 10.minutes,
    total_time: 6.days.ago.beginning_of_day + 10.minutes - 6.days.ago.beginning_of_day,
    created_at: 6.days.ago.beginning_of_day
  )
end
#７日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 7.days.ago.beginning_of_day,
    end_time: 7.days.ago.beginning_of_day + 5.minutes,
    total_time: 7.days.ago.beginning_of_day + 5.minutes - 7.days.ago.beginning_of_day,
    created_at: 7.days.ago.beginning_of_day
  )
end
#８日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 8.days.ago.beginning_of_day,
    end_time: 8.days.ago.beginning_of_day + 50.minutes,
    total_time: 8.days.ago.beginning_of_day + 50.minutes - 8.days.ago.beginning_of_day,
    created_at: 8.days.ago.beginning_of_day
  )
end
#９日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 9.days.ago.beginning_of_day,
    end_time: 9.days.ago.beginning_of_day + 10.minutes,
    total_time: 9.days.ago.beginning_of_day + 10.minutes - 9.days.ago.beginning_of_day,
    created_at: 9.days.ago.beginning_of_day
  )
end
#１０日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 10.days.ago.beginning_of_day,
    end_time: 10.days.ago.beginning_of_day + 1.hours,
    total_time: 10.days.ago.beginning_of_day + 1.hours - 10.days.ago.beginning_of_day,
    created_at: 10.days.ago.beginning_of_day
  )
end
#１1日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 11.days.ago.beginning_of_day,
    end_time: 11.days.ago.beginning_of_day + 30.minutes,
    total_time: 11.days.ago.beginning_of_day + 30.minutes - 11.days.ago.beginning_of_day,
    created_at: 11.days.ago.beginning_of_day
  )
end
#１2日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 12.days.ago.beginning_of_day,
    end_time: 12.days.ago.beginning_of_day + 45.minutes,
    total_time: 12.days.ago.beginning_of_day + 45.minutes - 12.days.ago.beginning_of_day,
    created_at: 12.days.ago.beginning_of_day
  )
end
#１3日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 13.days.ago.beginning_of_day,
    end_time: 13.days.ago.beginning_of_day + 50.minutes,
    total_time: 13.days.ago.beginning_of_day + 50.minutes - 13.days.ago.beginning_of_day,
    created_at: 13.days.ago.beginning_of_day
  )
end
#１4日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 14.days.ago.beginning_of_day,
    end_time: 14.days.ago.beginning_of_day + 1.hours,
    total_time: 14.days.ago.beginning_of_day + 1.hours - 14.days.ago.beginning_of_day,
    created_at: 14.days.ago.beginning_of_day
  )
end
#15日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 15.days.ago.beginning_of_day,
    end_time: 15.days.ago.beginning_of_day + 25.minutes,
    total_time: 15.days.ago.beginning_of_day + 25.minutes - 15.days.ago.beginning_of_day,
    created_at: 15.days.ago.beginning_of_day
  )
end
#17日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 17.days.ago.beginning_of_day,
    end_time: 17.days.ago.beginning_of_day + 40.minutes,
    total_time: 17.days.ago.beginning_of_day + 40.minutes - 17.days.ago.beginning_of_day,
    created_at: 17.days.ago.beginning_of_day
  )
end
#19日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 19.days.ago.beginning_of_day,
    end_time: 19.days.ago.beginning_of_day + 60.minutes,
    total_time: 19.days.ago.beginning_of_day + 60.minutes - 19.days.ago.beginning_of_day,
    created_at: 19.days.ago.beginning_of_day
  )
end
#22日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 22.days.ago.beginning_of_day,
    end_time: 22.days.ago.beginning_of_day + 90.minutes,
    total_time: 22.days.ago.beginning_of_day + 90.minutes - 22.days.ago.beginning_of_day,
    created_at: 22.days.ago.beginning_of_day
  )
end
#24日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 24.days.ago.beginning_of_day,
    end_time: 24.days.ago.beginning_of_day + 15.minutes,
    total_time: 24.days.ago.beginning_of_day + 15.minutes - 24.days.ago.beginning_of_day,
    created_at: 24.days.ago.beginning_of_day
  )
end
#25日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 25.days.ago.beginning_of_day,
    end_time: 25.days.ago.beginning_of_day + 10.minutes,
    total_time: 25.days.ago.beginning_of_day + 10.minutes - 25.days.ago.beginning_of_day,
    created_at: 25.days.ago.beginning_of_day
  )
end
#29日前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 29.days.ago.beginning_of_day,
    end_time: 29.days.ago.beginning_of_day + 3.minutes,
    total_time: 29.days.ago.beginning_of_day + 3.minutes - 29.days.ago.beginning_of_day,
    created_at: 29.days.ago.beginning_of_day
  )
end

#1ヶ月前 月初・月末
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 1.months.ago.beginning_of_month,
    end_time: 1.months.ago.beginning_of_month + 30.minutes,
    total_time: 1.months.ago.beginning_of_month + 30.minutes - 1.months.ago.beginning_of_month,
    created_at: 1.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 1.months.ago.end_of_month.beginning_of_day,
    end_time: 1.months.ago.end_of_month + 30.minutes,
    total_time: 1.months.ago.end_of_month + 30.minutes - 1.months.ago.end_of_month.beginning_of_day,
    created_at: 1.months.ago.beginning_of_month
  )
end
#2ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 2.months.ago.beginning_of_month,
    end_time: 2.months.ago.beginning_of_month + 40.minutes,
    total_time: 2.months.ago.beginning_of_month + 40.minutes - 2.months.ago.beginning_of_month,
    created_at: 2.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 2.months.ago.end_of_month.beginning_of_day,
    end_time: 2.months.ago.end_of_month + 40.minutes,
    total_time: 2.months.ago.end_of_month + 40.minutes - 2.months.ago.end_of_month.beginning_of_day,
    created_at: 2.months.ago.beginning_of_month
  )
end
#３ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 3.months.ago.beginning_of_month,
    end_time: 3.months.ago.beginning_of_month + 50.minutes,
    total_time: 3.months.ago.beginning_of_month + 50.minutes - 3.months.ago.beginning_of_month,
    created_at: 3.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 3.months.ago.end_of_month.beginning_of_day,
    end_time: 3.months.ago.end_of_month + 50.minutes,
    total_time: 3.months.ago.end_of_month + 50.minutes - 3.months.ago.end_of_month.beginning_of_day,
    created_at: 3.months.ago.beginning_of_month
  )
end
#4ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 4.months.ago.beginning_of_month,
    end_time: 4.months.ago.beginning_of_month + 60.minutes,
    total_time: 4.months.ago.beginning_of_month + 60.minutes - 4.months.ago.beginning_of_month,
    created_at: 4.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 4.months.ago.end_of_month.beginning_of_day,
    end_time: 4.months.ago.end_of_month + 60.minutes,
    total_time: 4.months.ago.end_of_month + 60.minutes - 4.months.ago.end_of_month.beginning_of_day,
    created_at: 4.months.ago.beginning_of_month
  )
end
#５ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 5.months.ago.beginning_of_month,
    end_time: 5.months.ago.beginning_of_month + 70.minutes,
    total_time: 5.months.ago.beginning_of_month + 70.minutes - 5.months.ago.beginning_of_month,
    created_at: 5.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 5.months.ago.end_of_month.beginning_of_day,
    end_time: 5.months.ago.end_of_month + 80.minutes,
    total_time: 5.months.ago.end_of_month + 80.minutes - 5.months.ago.end_of_month.beginning_of_day,
    created_at: 5.months.ago.beginning_of_month
  )
end
#６ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 6.months.ago.beginning_of_month,
    end_time: 6.months.ago.beginning_of_month + 90.minutes,
    total_time: 6.months.ago.beginning_of_month + 90.minutes - 6.months.ago.beginning_of_month,
    created_at: 6.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 6.months.ago.end_of_month.beginning_of_day,
    end_time: 6.months.ago.end_of_month + 90.minutes,
    total_time: 6.months.ago.end_of_month + 90.minutes - 6.months.ago.end_of_month.beginning_of_day,
    created_at: 6.months.ago.beginning_of_month
  )
end
#７ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 7.months.ago.beginning_of_month,
    end_time: 7.months.ago.beginning_of_month + 80.minutes,
    total_time: 7.months.ago.beginning_of_month + 80.minutes - 7.months.ago.beginning_of_month,
    created_at: 7.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 7.months.ago.end_of_month.beginning_of_day,
    end_time: 7.months.ago.end_of_month + 80.minutes,
    total_time: 7.months.ago.end_of_month + 80.minutes - 7.months.ago.end_of_month.beginning_of_day,
    created_at: 7.months.ago.beginning_of_month
  )
end
#８ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 8.months.ago.beginning_of_month,
    end_time: 8.months.ago.beginning_of_month + 70.minutes,
    total_time: 8.months.ago.beginning_of_month + 70.minutes - 8.months.ago.beginning_of_month,
    created_at: 8.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 8.months.ago.end_of_month.beginning_of_day,
    end_time: 8.months.ago.end_of_month + 70.minutes,
    total_time: 8.months.ago.end_of_month + 70.minutes - 8.months.ago.end_of_month.beginning_of_day,
    created_at: 8.months.ago.beginning_of_month
  )
end
#９ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 9.months.ago.beginning_of_month,
    end_time: 9.months.ago.beginning_of_month + 60.minutes,
    total_time: 9.months.ago.beginning_of_month + 60.minutes - 9.months.ago.beginning_of_month,
    created_at: 9.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 9.months.ago.end_of_month.beginning_of_day,
    end_time: 9.months.ago.end_of_month + 60.minutes,
    total_time: 9.months.ago.end_of_month + 60.minutes - 9.months.ago.end_of_month.beginning_of_day,
    created_at: 9.months.ago.beginning_of_month
  )
end
#10ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 10.months.ago.beginning_of_month,
    end_time: 10.months.ago.beginning_of_month + 50.minutes,
    total_time: 10.months.ago.beginning_of_month + 50.minutes - 10.months.ago.beginning_of_month,
    created_at: 10.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 10.months.ago.end_of_month.beginning_of_day,
    end_time: 10.months.ago.end_of_month + 50.minutes,
    total_time: 10.months.ago.end_of_month + 50.minutes - 10.months.ago.end_of_month.beginning_of_day,
    created_at: 10.months.ago.beginning_of_month
  )
end
#11ヶ月前
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 11.months.ago.beginning_of_month,
    end_time: 11.months.ago.beginning_of_month + 40.minutes,
    total_time: 11.months.ago.beginning_of_month + 40.minutes - 11.months.ago.beginning_of_month,
    created_at: 11.months.ago.beginning_of_month
  )
end
50.times do |n|
  ChannelTime.seed(
    user_channel_id:  UserChannel.offset(rand(1..29)).first.id,
    start_time: 11.months.ago.end_of_month.beginning_of_day,
    end_time: 11.months.ago.end_of_month + 40.minutes,
    total_time: 11.months.ago.end_of_month + 40.minutes - 11.months.ago.end_of_month.beginning_of_day,
    created_at: 11.months.ago.end_of_month.beginning_of_day
  )
end