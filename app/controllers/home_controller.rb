class HomeController < ApplicationController
  def top; end

  def terms_of_service; end

  def privacy_policy; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position)

    # これまでユーザーが使用したボイスチャンネル使用時間
    all_time_so_far = current_user.channel_times.group_id.total_time
    # 時間表示用
    @all_time_so_far = caliculate_time(all_time_so_far.values.sum)
    # グラフ用
    @all_time_so_far_graph = {}
    @all_time_so_far_graph['合計時間'] = shaped_time(all_time_so_far.values.sum)
    # チャンネルの使用時間トップ5を算出
    rank_sort = all_time_so_far.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_so_far_rank = {})

    # 各チャンネルそれぞれの使用時間グラフ
    channel_sort = all_time_so_far.sort_by { |_key, value| value }.reverse.to_h
    sort_time_for_each_channel(channel_sort, @time_for_each_channel_graph = {})

    # 今日のチャンネルの使用時間
    all_time_today = current_user.channel_times.date(Time.now.all_day).group_id.total_time
    # 時間表示用
    @all_time_today = caliculate_time(all_time_today.values.sum)
    # グラフ用
    channel_sort = all_time_today.sort_by { |_key, value| value }.reverse.to_h
    sort_time_for_each_channel(channel_sort, @all_time_today_graph = {})
    # チャンネルの使用時間トップ5を算出
    rank_sort = all_time_today.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_today_rank = {})

    # ここ１週間のチャンネルの使用時間
    all_time_past_week = current_user.channel_times.date(6.days.ago.beginning_of_day..Time.now.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_past_week = caliculate_time(all_time_past_week.values.sum)
    # グラフ用
    @all_time_past_week_graph = (0..6).to_a.reverse.map do |day|
      day_time = current_user.channel_times.date(day.day.ago.all_day).total_time
      { data: [[day.zero? ? '今日' : "#{day}日前", shaped_time(day_time)]]}
    end
    # チャンネル使用時間トップ5を算出
    rank_sort = all_time_past_week.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_past_week_rank = {})

    # 今月のチャンネル使用時間
    all_time_this_month = current_user.channel_times.date(Time.now.all_month).total_time
    # 時間表示用
    @all_time_this_month = caliculate_time(all_time_this_month)
    # グラフ用
    @all_time_months_graph = (0..11).to_a.reverse.map do |month|
      month_time = current_user.channel_times.date(month.month.ago.all_month).total_time
      {data: [[month.zero? ? '今月' : "#{month}ヶ月前", shaped_time(month_time) ]]}
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

  def sort_time_for_each_channel(channel_sort, hash_container)
    channel_sort.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      hash_container[channel.name] = shaped_time(value)
    end
  end

end
