class GuildsController < ApplicationController
  def show
    @guild = Guild.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position).map { |user_channel| user_channel }

    user_channel = current_user.user_channels.where(channel_id: @guild.channels.ids).pluck(:id)

    # これまでのサーバー内のチャンネル使用時間を計算
    server_time_so_far = ChannelTime.user_channel(user_channel).total_time
    # 時間表示用
    @server_time_so_far = caliculate_time(server_time_so_far)
    # グラフ表示用
    @server_time_so_far_graph = {}
    @server_time_so_far_graph['合計時間'] = shaped_time(server_time_so_far)
    # サーバー内のこれまでのチャンネル使用時間トップ5を算出
    server_time_so_far_rank = ChannelTime.user_channel(user_channel).group_id.total_time
    rank_sort = server_time_so_far_rank.sort_by { |key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_so_far_rank = {})

    # 今日のチャンネル使用時間が算出される
    server_time_today = ChannelTime.user_channel(user_channel).date(Time.now.all_day).total_time
    # 時間表示用
    @server_time_today = caliculate_time(server_time_today)
    # グラフ用
    @server_time_today_graph = {}
    @server_time_today_graph[@guild.name] = shaped_time(server_time_today)
    # 今日のサーバー内のチャンネル使用時間トップ5を算出
    server_time_today_rank = ChannelTime.user_channel(user_channel).date(Time.now.all_day).group_id.total_time
    rank_sort = server_time_today_rank.sort_by { |key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_today_rank = {})

    # ここ１週間のサーバー使用時間
    server_time_past_week = ChannelTime.user_channel(user_channel).date(6.days.ago.beginning_of_day..Time.now.end_of_day).total_time
    # 時間表示用
    @server_time_past_week = caliculate_time(server_time_past_week)
    # グラフ用
    on_day = ChannelTime.user_channel(user_channel).date(Time.now.all_day).total_time
    day_ago = ChannelTime.user_channel(user_channel).date(1.day.ago.all_day).total_time
    two_days_ago = ChannelTime.user_channel(user_channel).date(2.days.ago.all_day).total_time
    three_days_ago = ChannelTime.user_channel(user_channel).date(3.days.ago.all_day).total_time
    four_days_ago = ChannelTime.user_channel(user_channel).date(4.days.ago.all_day).total_time
    five_days_ago = ChannelTime.user_channel(user_channel).date(5.days.ago.all_day).total_time
    six_days_ago = ChannelTime.user_channel(user_channel).date(6.days.ago.all_day).total_time
    on_day = [['今日', shaped_time(on_day)]]
    day_ago = [['１日前', shaped_time(day_ago)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago)]]
    @server_time_past_week_graph = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
                                    { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: on_day }]
    # 今日から6日前までのサーバー内のチャンネル使用時間トップ5を算出
    server_time_past_week_rank = ChannelTime.user_channel(user_channel).date(6.days.ago.beginning_of_day..Time.now.end_of_day).group_id.total_time
    rank_sort = server_time_past_week_rank.sort_by { |key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @server_time_past_week_rank = {})

    # 今月のチャンネル使用時間
    server_time_this_month = ChannelTime.user_channel(user_channel).date(Time.now.all_month).total_time
    # 時間表示用
    @server_time_this_month = caliculate_time(server_time_this_month)
    # 数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = ChannelTime.user_channel(user_channel).date(1.month.ago.all_month).total_time
    two_month_ago = ChannelTime.user_channel(user_channel).date(2.months.ago.all_month).total_time
    three_month_ago = ChannelTime.user_channel(user_channel).date(3.months.ago.all_month).total_time
    four_month_ago = ChannelTime.user_channel(user_channel).date(4.months.ago.all_month).total_time
    five_month_ago = ChannelTime.user_channel(user_channel).date(5.months.ago.all_month).total_time
    six_month_ago = ChannelTime.user_channel(user_channel).date(6.months.ago.all_month).total_time
    seven_month_ago = ChannelTime.user_channel(user_channel).date(7.months.ago.all_month).total_time
    eight_month_ago = ChannelTime.user_channel(user_channel).date(8.months.ago.all_month).total_time
    nine_month_ago = ChannelTime.user_channel(user_channel).date(9.months.ago.all_month).total_time
    ten_month_ago = ChannelTime.user_channel(user_channel).date(10.months.ago.all_month).total_time
    eleven_month_ago = ChannelTime.user_channel(user_channel).date(11.months.ago.all_month).total_time
    this_month_time = [['今月', shaped_time(server_time_this_month)]]
    a_month_ago_time = [['1ヶ月前', shaped_time(a_month_ago)]]
    two_month_ago_time = [['2ヶ月前', shaped_time(two_month_ago)]]
    three_month_ago_time = [['3ヶ月前', shaped_time(three_month_ago)]]
    four_month_ago_time = [['4ヶ月前', shaped_time(four_month_ago)]]
    five_month_ago_time = [['5ヶ月前', shaped_time(five_month_ago)]]
    six_month_ago_time = [['6ヶ月前', shaped_time(six_month_ago)]]
    seven_month_ago_time = [['7ヶ月前', shaped_time(seven_month_ago)]]
    eight_month_ago_time = [['8ヶ月前', shaped_time(eight_month_ago)]]
    nine_month_ago_time = [['9ヶ月前', shaped_time(nine_month_ago)]]
    ten_month_ago_time = [['10ヶ月前', shaped_time(ten_month_ago)]]
    eleven_month_ago_time = [['11ヶ月前', shaped_time(eleven_month_ago)]]
    @server_time_months_graph = [{ data: eleven_month_ago_time }, { data: ten_month_ago_time }, { data: nine_month_ago_time },
                     { data: eight_month_ago_time }, { data: seven_month_ago_time }, { data: six_month_ago_time },
                     {  data: five_month_ago_time }, { data: four_month_ago_time }, { data: three_month_ago_time },
                     { data: two_month_ago_time }, { data: a_month_ago_time }, { data: this_month_time }]
  end

  private

  def top_five_channel_times(rank_sort, hash_container)
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      hash_container[channel.name] = shaped_time
    end
  end

end
