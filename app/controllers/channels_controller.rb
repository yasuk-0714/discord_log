class ChannelsController < ApplicationController
  def show
    @channel = Channel.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    user_channel = current_user.user_channels.where(channel_id: @channel.id).pluck(:id)

    #今までのチャンネルの使用時間が算出される
    channel_time = ChannelTime.where(user_channel_id: user_channel).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @channel_time = caliculate_time(channel_time.values[0])
    #グラフ
    @channel_time_graph = {}
    @channel_time_graph['合計時間'] = shaped_time(channel_time.values[0])

    #今日のチャンネル使用時間が算出される
    channel_time_today = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @channel_time_today = caliculate_time(channel_time_today.values[0])
    #グラフ用
    @channel_time_today_graph = {}
    @channel_time_today_graph[@channel.name] = shaped_time(channel_time_today.values[0])

    #今日から6日前までの使用時間
    channel_time_week = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @channel_time_week = caliculate_time(channel_time_week.values[0])
    #グラフ用
    on_day = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [['今日', shaped_time(on_day.values.sum)]]
    day_ago = [['１日前', shaped_time(day_ago.values.sum)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago.values.sum)]]
    @weeks_graph = [{name: '6日前', data: six_days_ago}, {name: '５日前', data: five_days_ago}, {name: '４日前', data: four_days_ago},
                    {name:'３日前', data: three_days_ago}, {name: '２日前', data: two_days_ago}, {name: '１日前', data: day_ago}, {name: '今日', data: on_day}]

    #今月のチャンネル使用時間
    channel_time_month = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @channel_time_month = caliculate_time(channel_time_month.values[0])

    #数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [['今月', shaped_time(channel_time_month.values.sum)]]
    a_month_ago_time = [['1ヶ月前', shaped_time(a_month_ago.values.sum)]]
    two_month_ago_time = [['2ヶ月前', shaped_time(two_month_ago.values.sum)]]
    three_month_ago_time = [['3ヶ月前', shaped_time(three_month_ago.values.sum)]]
    four_month_ago_time = [['4ヶ月前', shaped_time(four_month_ago.values.sum)]]
    five_month_ago_time = [['5ヶ月前', shaped_time(five_month_ago.values.sum)]]
    six_month_ago_time = [['6ヶ月前', shaped_time(six_month_ago.values.sum)]]
    seven_month_ago_time = [['7ヶ月前', shaped_time(seven_month_ago.values.sum)]]
    eight_month_ago_time = [['8ヶ月前', shaped_time(eight_month_ago.values.sum)]]
    nine_month_ago_time = [['9ヶ月前', shaped_time(nine_month_ago.values.sum)]]
    ten_month_ago_time = [['10ヶ月前', shaped_time(ten_month_ago.values.sum)]]
    eleven_month_ago_time = [['11ヶ月前', shaped_time(eleven_month_ago.values.sum)]]
    @months_graph = [{name: '11ヶ月前', data: eleven_month_ago_time}, {name: '10ヶ月前', data: ten_month_ago_time}, {name: '9ヶ月前', data: nine_month_ago_time},
                      {name: '8ヶ月前', data: eight_month_ago_time}, {name: '7ヶ月前', data: seven_month_ago_time}, {name: '6ヶ月前', data: six_month_ago_time},
                      {name: '5ヶ月前', data: five_month_ago_time}, {name: '4ヶ月前', data: four_month_ago_time}, {name: '3ヶ月前', data: three_month_ago_time},
                      {name: '2ヶ月前', data: two_month_ago_time}, {name: '1ヶ月前', data: a_month_ago_time}, {name: '今月', data: this_month_time}]
  end
end
