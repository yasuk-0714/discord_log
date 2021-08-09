class HomeController < ApplicationController
  def top; end

  def terms_of_service; end

  def privacy_policy; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(:position).map { |channel| channel }

    # ユーザーが所持しているチャンネルごとに時間を算出
    time_all = current_user.channel_times.group(:user_channel_id).sum(:total_time)

    # ユーザーが参加しているチャンネルの総合時間 :表示用
    @total_time = caliculate_time(time_all.values.sum)
    # ユーザーが参加しているチャンネルの総合時間 :グラフ用
    @time_all = {}
    @time_all[t('defaults.common.total_time')] = shaped_time(time_all.values.sum)

    # 全てのユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_all = time_all.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_all = {}
    top_five_channel_times(user_channel_time_each_all, @user_channel_time_each_all)

    # これまでのユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.sort_by { |key, value| value }.reverse.to_h.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_all[channel.name] = shaped_time
    end

    # 今日のチャンネルの使用時間
    user_channels_time_today = current_user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    @total_time_today = caliculate_time(user_channels_time_today.values.sum)
    @user_channels_time_today = {}
    user_channels_time_today.sort_by { |key, value| value }.reverse.to_h.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_today[channel.name] = shaped_time
    end

    # 今日のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_today = user_channels_time_today.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_today = {}
    top_five_channel_times(user_channel_time_each_today, @user_channel_time_each_today)

    # 今日から６日前までのチャンネルの使用時間
    user_channels_time_week = current_user.channel_times.where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_week = caliculate_time(user_channels_time_week.values.sum)
    # グラフ用
    on_day = current_user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = current_user.channel_times.where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago = current_user.channel_times.where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = current_user.channel_times.where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = current_user.channel_times.where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = current_user.channel_times.where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = current_user.channel_times.where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [[t('defaults.day.today'), shaped_time(on_day.values.sum)]]
    day_ago = [[t('defaults.day.1_day_ago'), shaped_time(day_ago.values.sum)]]
    two_days_ago = [[t('defaults.day.2_days_ago'), shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [[t('defaults.day.3_days_ago'), shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [[t('defaults.day.4_days_ago'), shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [[t('defaults.day.5_days_ago'), shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [[t('defaults.day.6_days_ago'), shaped_time(six_days_ago.values.sum)]]
    @graph = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
              { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: on_day }]
    # 今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_month = user_channels_time_week.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_month = {}
    top_five_channel_times(user_channel_time_each_month, @user_channel_time_each_month)

    # 今月のチャンネル使用時間
    user_channels_time_month = current_user.channel_times.where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_month = caliculate_time(user_channels_time_month.values.sum)

    # 数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = current_user.channel_times.where(created_at: 1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = current_user.channel_times.where(created_at: 2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = current_user.channel_times.where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = current_user.channel_times.where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = current_user.channel_times.where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = current_user.channel_times.where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = current_user.channel_times.where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = current_user.channel_times.where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = current_user.channel_times.where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = current_user.channel_times.where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = current_user.channel_times.where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [[t('defaults.month.this_month'), shaped_time(user_channels_time_month.values.sum)]]
    a_month_ago_time = [[t('defaults.month.1_month_ago'), shaped_time(a_month_ago.values.sum)]]
    two_month_ago_time = [[t('defaults.month.2_months_ago'), shaped_time(two_month_ago.values.sum)]]
    three_month_ago_time = [[t('defaults.month.3_months_ago'), shaped_time(three_month_ago.values.sum)]]
    four_month_ago_time = [[t('defaults.month.4_months_ago'), shaped_time(four_month_ago.values.sum)]]
    five_month_ago_time = [[t('defaults.month.5_months_ago'), shaped_time(five_month_ago.values.sum)]]
    six_month_ago_time = [[t('defaults.month.6_months_ago'), shaped_time(six_month_ago.values.sum)]]
    seven_month_ago_time = [[t('defaults.month.7_months_ago'), shaped_time(seven_month_ago.values.sum)]]
    eight_month_ago_time = [[t('defaults.month.8_months_ago'), shaped_time(eight_month_ago.values.sum)]]
    nine_month_ago_time = [[t('defaults.month.9_months_ago'), shaped_time(nine_month_ago.values.sum)]]
    ten_month_ago_time = [[t('defaults.month.10_months_ago'), shaped_time(ten_month_ago.values.sum)]]
    eleven_month_ago_time = [[t('defaults.month.11_months_ago'), shaped_time(eleven_month_ago.values.sum)]]
    @months_graph = [{ data: eleven_month_ago_time }, { data: ten_month_ago_time }, { data: nine_month_ago_time },
                     { data: eight_month_ago_time }, { data: seven_month_ago_time }, { data: six_month_ago_time },
                     { data: five_month_ago_time }, { data: four_month_ago_time }, { data: three_month_ago_time },
                     { data: two_month_ago_time }, { data: a_month_ago_time }, { data: this_month_time }]
  end

  private

  def top_five_channel_times(sort_data, new_hash)
    sort_data.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      new_hash[channel.name] = shaped_time
    end
  end
end
