class HomeController < ApplicationController

  def index; end
  def terms_of_service; end
  def privacy_policy; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    #ユーザーが所持しているチャンネルごとに時間を算出
    time_all = current_user.channel_times.group(:user_channel_id).sum(:total_time)

    #ユーザーが参加しているチャンネルの総合時間 :表示用
    @total_time = caliculate_time(time_all.values.sum)
    #ユーザーが参加しているチャンネルの総合時間 :グラフ用
    @time_all = {}
    @time_all['合計時間'] = shaped_time(time_all.values.sum)

    #全てのユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_all = time_all.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_all = {}
    user_channel_time_each_all.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_all[channel.name] = shaped_time
    end

    #これまでのユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.sort_by {|k,v| v}.reverse.to_h.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_all[channel.name] = shaped_time
    end

    #今日のチャンネルの使用時間
    user_channels_time_today = current_user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    @total_time_today = caliculate_time(user_channels_time_today.values.sum)
    @user_channels_time_today = {}
    user_channels_time_today.sort_by {|k,v| v}.reverse.to_h.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_today[channel.name] = shaped_time
    end

    #今日のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_today = user_channels_time_today.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_today = {}
    user_channel_time_each_today.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_today[channel.name] = shaped_time
    end

    #今日から６日前までのチャンネルの使用時間
    user_channels_time_week = current_user.channel_times.where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_week = caliculate_time(user_channels_time_week.values.sum)
    #グラフ用
    on_day = current_user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = current_user.channel_times.where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago =  current_user.channel_times.where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = current_user.channel_times.where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = current_user.channel_times.where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = current_user.channel_times.where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = current_user.channel_times.where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [['今日', shaped_time(on_day.values.sum)]]
    day_ago = [['１日前', shaped_time(day_ago.values.sum)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago.values.sum)]]
    @graph = [{name: '6日前', data: six_days_ago}, {name: '５日前', data: five_days_ago}, {name: '４日前', data: four_days_ago},
              {name:'３日前', data: three_days_ago}, {name: '２日前', data: two_days_ago}, {name: '１日前', data: day_ago}, {name: '今日', data: on_day}]
    #今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_month = user_channels_time_week.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_month = {}
    user_channel_time_each_month.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_month[channel.name] = shaped_time
    end

    #今月のチャンネル使用時間
    user_channels_time_month = current_user.channel_times.where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_month = caliculate_time(user_channels_time_month.values.sum)

    #数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = current_user.channel_times.where(created_at:  1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = current_user.channel_times.where(created_at:  2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = current_user.channel_times.where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = current_user.channel_times.where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = current_user.channel_times.where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = current_user.channel_times.where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = current_user.channel_times.where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = current_user.channel_times.where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = current_user.channel_times.where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = current_user.channel_times.where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = current_user.channel_times.where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [['今月', shaped_time(user_channels_time_month.values.sum)]]
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
    # user_channels_time_year = current_user.channel_times.where(created_at: Time.now.all_year).group(:user_channel_id).sum(:total_time)
    # @user_channels_time_year = caliculate_time(user_channels_time_year.values.sum)
  end
end

