class HomeController < ApplicationController
  def top; end

  def terms_of_service; end

  def privacy_policy; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position).map { |channel| channel }

    # これまでのユーザーが使用したボイスチャンネル時間の全て
    all_time_so_far = current_user.channel_times.group(:user_channel_id).sum(:total_time)

    # これまでのユーザーが参加しているチャンネルの総合時間 :表示用
    @all_time_so_far = caliculate_time(all_time_so_far.values.sum)
    # これまでのユーザーが参加しているチャンネルの総合時間 :グラフ用
    @all_time_so_far_graph = {}
    @all_time_so_far_graph['合計時間'] = shaped_time(all_time_so_far.values.sum)

    # これまでユーザーが使用した全てのチャンネルの使用時間トップ5を算出
    rank_sort = all_time_so_far.sort_by { |key, value| value }.reverse.first(5).to_h
    @all_time_so_far_rank = {}
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @all_time_so_far_rank[channel.name] = shaped_time
    end

    # 各チャンネルそれぞれの使用時間グラフ
    @time_for_each_channel_graph = {}
    all_time_so_far.sort_by { |key, value| value }.reverse.to_h.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @time_for_each_channel_graph[channel.name] = shaped_time
    end

    # 今日のチャンネルの使用時間
    all_time_today = current_user.channel_times.date(Time.now.all_day).group_id.total_time
    #今日のチャンネル使用時間 :表示用
    @all_time_today = caliculate_time(all_time_today.values.sum)
    #今日のチャンネル使用時間 :グラフ用
    channel_sort = all_time_today.sort_by { |key, value| value }.reverse.to_h
    @all_time_today_graph = {}
    rank_sort.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @all_time_today_graph[channel.name] = shaped_time
    end

    # 今日のユーザーチャンネルの使用時間トップ5を算出
    rank_sort = all_time_today.sort_by { |key, value| value }.reverse.first(5).to_h
    @all_time_today_rank = {}
    # top_five_channel_times(user_channel_time_each_today, @user_channel_time_each_today)
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @all_time_today_rank[channel.name] = shaped_time
    end

    # 今日から６日前までのチャンネルの使用時間
    all_time_past_week = current_user.channel_times.date(6.days.ago.beginning_of_day..Time.now.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_past_week = caliculate_time(all_time_past_week.values.sum)
    # グラフ用
    on_day = current_user.channel_times.date(Time.now.all_day).group_id.total_time
    day_ago = current_user.channel_times.date(1.day.ago.all_day).group_id.total_time
    two_days_ago = current_user.channel_times.date(2.days.ago.all_day).group_id.total_time
    three_days_ago = current_user.channel_times.date(3.days.ago.all_day).group_id.total_time
    four_days_ago = current_user.channel_times.date(4.days.ago.all_day).group_id.total_time
    five_days_ago = current_user.channel_times.date(5.days.ago.all_day).group_id.total_time
    six_days_ago = current_user.channel_times.date(6.days.ago.all_day).group_id.total_time
    on_day = [['今日', shaped_time(on_day.values.sum)]]
    day_ago = [['１日前', shaped_time(day_ago.values.sum)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [['3日前', shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [['6日前', shaped_time(six_days_ago.values.sum)]]
    @all_time_past_week_graph = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
                                { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: on_day }]
    # 今週のユーザーチャンネルの使用時間トップ5を算出
    rank_sort = all_time_past_week.sort_by { |key, value| value }.reverse.first(5).to_h
    @all_time_past_week_rank = {}
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @all_time_past_week_rank[channel.name] = shaped_time
    end

    # 今月のチャンネル使用時間
    all_time_this_month = current_user.channel_times.date(Time.now.all_month).group_id.total_time
    # 時間表示用
    @all_time_this_month = caliculate_time(all_time_this_month.values.sum)

    # 数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = current_user.channel_times.date(1.month.ago.all_month).group_id.total_time
    two_month_ago = current_user.channel_times.date(2.months.ago.all_month).group_id.total_time
    three_month_ago = current_user.channel_times.date(3.months.ago.all_month).group_id.total_time
    four_month_ago = current_user.channel_times.date(4.months.ago.all_month).group_id.total_time
    five_month_ago = current_user.channel_times.date(5.months.ago.all_month).group_id.total_time
    six_month_ago = current_user.channel_times.date(6.months.ago.all_month).group_id.total_time
    seven_month_ago = current_user.channel_times.date(7.months.ago.all_month).group_id.total_time
    eight_month_ago = current_user.channel_times.date(8.months.ago.all_month).group_id.total_time
    nine_month_ago = current_user.channel_times.date(9.months.ago.all_month).group_id.total_time
    ten_month_ago = current_user.channel_times.date(10.months.ago.all_month).group_id.total_time
    eleven_month_ago = current_user.channel_times.date(11.months.ago.all_month).group_id.total_time
    this_month_time = [['今月', shaped_time(all_time_this_month.values.sum)]]
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
    @all_time_months_graph = [{ data: eleven_month_ago_time }, { data: ten_month_ago_time }, { data: nine_month_ago_time },
                     { data: eight_month_ago_time }, { data: seven_month_ago_time }, { data: six_month_ago_time },
                     { data: five_month_ago_time }, { data: four_month_ago_time }, { data: three_month_ago_time },
                     { data: two_month_ago_time }, { data: a_month_ago_time }, { data: this_month_time }]
  end

end
