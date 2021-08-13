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
    @channel_time_past_week_graph = (0..6).to_a.reverse.map do |day|
      day_time = ChannelTime.user_channel(user_channel).date(day.day.ago.all_day).total_time
      { data: [[day.zero? ? '今日' : "#{day}日前", shaped_time(day_time)]] }
    end

    # 今月のチャンネル使用時間
    channel_time_this_month = ChannelTime.user_channel(user_channel).date(Time.now.all_month).total_time
    # 時間表示用
    @channel_time_this_month = caliculate_time(channel_time_this_month)
    # グラフ用
    @channel_time_months_graph = (0..11).to_a.reverse.map do |month|
      month_time = ChannelTime.user_channel(user_channel).date(month.month.ago.all_month).total_time
      { data: [[month.zero? ? '今月' : "#{month}ヶ月前", shaped_time(month_time)]] }
    end
  end
end
