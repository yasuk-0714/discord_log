class GuildsController < ApplicationController
  def show
    @guild = Guild.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position)

    user_channel = current_user.user_channels.where(channel_id: @guild.channels.ids).pluck(:id)

    # これまでのサーバー内のチャンネル使用時間
    server_time_so_far = ChannelTime.user_channel(user_channel).total_time
    # 時間表示用
    @server_time_so_far = caliculate_time(server_time_so_far)
    # グラフ表示用
    @server_time_so_far_graph = {}
    @server_time_so_far_graph['合計時間'] = shaped_time(server_time_so_far)
    # チャンネル使用時間トップ5を算出
    server_time_so_far_rank = ChannelTime.user_channel(user_channel).group_id.total_time
    rank_sort = server_time_so_far_rank.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_so_far_rank = {})

    # 今日のチャンネル使用時間
    server_time_today = ChannelTime.user_channel(user_channel).date(Time.now.all_day).total_time
    # 時間表示用
    @server_time_today = caliculate_time(server_time_today)
    # グラフ用
    @server_time_today_graph = {}
    @server_time_today_graph[@guild.name] = shaped_time(server_time_today)
    # チャンネル使用時間トップ5を算出
    server_time_today_rank = ChannelTime.user_channel(user_channel).date(Time.now.all_day).group_id.total_time
    rank_sort = server_time_today_rank.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_today_rank = {})

    # ここ１週間のサーバー使用時間
    server_time_past_week = ChannelTime.user_channel(user_channel).date(6.days.ago.beginning_of_day..Time.now.end_of_day).total_time
    # 時間表示用
    @server_time_past_week = caliculate_time(server_time_past_week)
    # グラフ用
    @server_time_past_week_graph = (0..6).to_a.reverse.map do |day|
      day_time = ChannelTime.user_channel(user_channel).date(day.day.ago.all_day).total_time
      { data: [[day.zero? ? '今日' : "#{day}日前", shaped_time(day_time)]] }
    end
    # チャンネル使用時間トップ5を算出
    server_time_past_week_rank = ChannelTime.user_channel(user_channel).date(6.days.ago.beginning_of_day..Time.now.end_of_day).group_id.total_time
    rank_sort = server_time_past_week_rank.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_past_week_rank = {})

    # 今月のチャンネル使用時間
    server_time_this_month = ChannelTime.user_channel(user_channel).date(Time.now.all_month).total_time
    # 時間表示用
    @server_time_this_month = caliculate_time(server_time_this_month)
    # グラフ用
    @server_time_months_graph = (0..11).to_a.reverse.map do |month|
      month_time = ChannelTime.user_channel(user_channel).date(month.month.ago.all_month).total_time
      { data: [[month.zero? ? '今月' : "#{month}ヶ月前", shaped_time(month_time)]] }
    end
  end

  private

  def top_five_channel_times(rank_sort, hash_container)
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      hash_container[channel.name] = caliculate_time(value)
    end
  end
end
