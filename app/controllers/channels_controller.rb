class ChannelsController < ApplicationController
  def show
    @channel = Channel.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position)
    user_channel = current_user.user_channels.find_by(channel_id: @channel)

    # 今までのチャンネルの使用時間
    channel_time_so_far = ChannelTime.user_channel(user_channel).total_time
    # 時間表示用
    @channel_time_so_far = caliculate_time(channel_time_so_far)
    # グラフ
    @channel_time_so_far_graph = {}
    @channel_time_so_far_graph['合計時間'] = shaped_time(channel_time_so_far)

    # 今日のチャンネル使用時間
    channel_time_today = ChannelTime.user_channel(user_channel).date(Time.now.all_day).total_time
    # 時間表示用
    @channel_time_today = caliculate_time(channel_time_today)
    # グラフ用
    @channel_time_today_graph = {}
    @channel_time_today_graph[@channel.name] = shaped_time(channel_time_today)

    # 今日から6日前までの使用時間
    channel_time_past_week = ChannelTime.user_channel(user_channel).date(6.days.ago.beginning_of_day..Time.now.end_of_day).total_time
    # 時間表示用
    @channel_time_past_week = caliculate_time(channel_time_past_week)
    # グラフ用
    today = ChannelTime.user_channel(user_channel).date(Time.now.all_day).total_time
    day_ago = ChannelTime.user_channel(user_channel).date(1.day.ago.all_day).total_time
    two_days_ago = ChannelTime.user_channel(user_channel).date(2.days.ago.all_day).total_time
    three_days_ago = ChannelTime.user_channel(user_channel).date(3.days.ago.all_day).total_time
    four_days_ago = ChannelTime.user_channel(user_channel).date(4.days.ago.all_day).total_time
    five_days_ago = ChannelTime.user_channel(user_channel).date(5.days.ago.all_day).total_time
    six_days_ago = ChannelTime.user_channel(user_channel).date(6.days.ago.all_day).total_time
    today = [['今日', shaped_time(today)]]
    day_ago = [['1日前', shaped_time(day_ago)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago)]]
    four_days_ago = [['4日前', shaped_time(four_days_ago)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago)]]
    @channel_time_past_week_graph = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
                                     { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: today }]

    # 今月のチャンネル使用時間
    channel_time_this_month = ChannelTime.user_channel(user_channel).date(Time.now.all_month).total_time
    # 時間表示用
    @channel_time_this_month = caliculate_time(channel_time_this_month)
    # グラフ用
    a_month_ago = ChannelTime.user_channel(user_channel).date(1.month.ago.all_month).total_time
    two_months_ago = ChannelTime.user_channel(user_channel).date(2.months.ago.all_month).total_time
    three_months_ago = ChannelTime.user_channel(user_channel).date(3.months.ago.all_month).total_time
    four_months_ago = ChannelTime.user_channel(user_channel).date(4.months.ago.all_month).total_time
    five_months_ago = ChannelTime.user_channel(user_channel).date(5.months.ago.all_month).total_time
    six_months_ago = ChannelTime.user_channel(user_channel).date(6.months.ago.all_month).total_time
    seven_months_ago = ChannelTime.user_channel(user_channel).date(7.months.ago.all_month).total_time
    eight_months_ago = ChannelTime.user_channel(user_channel).date(8.months.ago.all_month).total_time
    nine_months_ago = ChannelTime.user_channel(user_channel).date(9.months.ago.all_month).total_time
    ten_months_ago = ChannelTime.user_channel(user_channel).date(10.months.ago.all_month).total_time
    eleven_months_ago = ChannelTime.user_channel(user_channel).date(11.months.ago.all_month).total_time
    this_month_time = [['今月', shaped_time(channel_time_this_month)]]
    a_month_ago_time = [['1ヶ月前', shaped_time(a_month_ago)]]
    two_months_ago_time = [['2ヶ月前', shaped_time(two_months_ago)]]
    three_months_ago_time = [['3ヶ月前', shaped_time(three_months_ago)]]
    four_months_ago_time = [['4ヶ月前', shaped_time(four_months_ago)]]
    five_months_ago_time = [['5ヶ月前', shaped_time(five_months_ago)]]
    six_months_ago_time = [['6ヶ月前', shaped_time(six_months_ago)]]
    seven_months_ago_time = [['7ヶ月前', shaped_time(seven_months_ago)]]
    eight_months_ago_time = [['8ヶ月前', shaped_time(eight_months_ago)]]
    nine_months_ago_time = [['9ヶ月前', shaped_time(nine_months_ago)]]
    ten_months_ago_time = [['10ヶ月前', shaped_time(ten_months_ago)]]
    eleven_months_ago_time = [['11ヶ月前', shaped_time(eleven_months_ago)]]
    @channel_time_months_graph = [{ data: eleven_months_ago_time }, { data: ten_months_ago_time }, { data: nine_months_ago_time },
                                  { data: eight_months_ago_time }, { data: seven_months_ago_time }, { data: six_months_ago_time },
                                  { data: five_months_ago_time }, { data: four_months_ago_time }, { data: three_months_ago_time },
                                  { data: two_months_ago_time }, { data: a_month_ago_time }, { data: this_month_time }]
  end
end
