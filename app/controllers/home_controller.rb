class HomeController < ApplicationController

  def index; end

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
    #ユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_all[channel.name] = shaped_time
    end

    #今日のチャンネルの使用時間
    user_channels_time_today = current_user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    @total_time_today = caliculate_time(user_channels_time_today.values.sum)
    @user_channels_time_today = {}
    user_channels_time_today.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_today[channel.name] = shaped_time
    end

    #今週のチャンネルの使用時間
    user_channels_time_week = current_user.channel_times.where(created_at: Time.now.all_week).group(:user_channel_id).sum(:total_time)
    @user_channels_time_week = caliculate_time(user_channels_time_week.values.sum)
    #曜日ごとのチャンネル使用時間
    sunday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:sunday).beginning_of_day..Time.now.beginning_of_week(:sunday).end_of_day).group(:user_channel_id).sum(:total_time)
    monday =  current_user.channel_times.where(created_at: Time.now.beginning_of_week(:monday).beginning_of_day..Time.now.beginning_of_week(:monday).end_of_day).group(:user_channel_id).sum(:total_time)
    tuesday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:tuesday).beginning_of_day..Time.now.beginning_of_week(:tuesday).end_of_day).group(:user_channel_id).sum(:total_time)
    wednesday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:wednesday).beginning_of_day..Time.now.beginning_of_week(:wednesday).end_of_day).group(:user_channel_id).sum(:total_time)
    thursday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:thursday).beginning_of_day..Time.now.beginning_of_week(:thursday).end_of_day).group(:user_channel_id).sum(:total_time)
    friday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:friday).beginning_of_day..Time.now.beginning_of_week(:friday).end_of_day).group(:user_channel_id).sum(:total_time)
    saturday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:saturday).beginning_of_day..Time.now.beginning_of_week(:saturday).end_of_day).group(:user_channel_id).sum(:total_time)
    monday_time = [['月曜日', shaped_time(monday.values.sum)]]
    tuesday_time = [['火曜日', shaped_time(tuesday.values.sum)]]
    wednesday_time = [['水曜日', shaped_time(wednesday.values.sum)]]
    thursday_time = [['木曜日', shaped_time(thursday.values.sum)]]
    friday_time = [['金曜日', shaped_time(friday.values.sum)]]
    saturday_time = [['土曜日', shaped_time(saturday.values.sum)]]
    sunday_time = [['日曜日', shaped_time(sunday.values.sum)]]
    @graph = [{name: '月曜日', data: monday_time}, {name: '火曜日', data: tuesday_time}, {name: '水曜日', data: wednesday_time}, {name:'木曜日', data: thursday_time}, {name: '金曜日', data: friday_time}, {name: '土曜日', data: saturday_time}, {name: '日曜日', data: sunday_time}]

    #今月のチャンネル使用時間
    user_channels_time_month = current_user.channel_times.where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    @user_channels_time_month = caliculate_time(user_channels_time_month.values.sum)
    #数ヶ月前までのチャンネル使用時間
    a_month_ago = current_user.channel_times.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = current_user.channel_times.where(created_at: 2.month.ago.beginning_of_month..2.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = current_user.channel_times.where(created_at: 3.month.ago.beginning_of_month..3.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = current_user.channel_times.where(created_at: 4.month.ago.beginning_of_month..4.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = current_user.channel_times.where(created_at: 5.month.ago.beginning_of_month..5.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = current_user.channel_times.where(created_at: 6.month.ago.beginning_of_month..6.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = current_user.channel_times.where(created_at: 7.month.ago.beginning_of_month..7.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = current_user.channel_times.where(created_at: 8.month.ago.beginning_of_month..8.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = current_user.channel_times.where(created_at: 9.month.ago.beginning_of_month..9.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = current_user.channel_times.where(created_at: 10.month.ago.beginning_of_month..10.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = current_user.channel_times.where(created_at: 11.month.ago.beginning_of_month..11.month.ago.end_of_month).group(:user_channel_id).sum(:total_time)
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
    @months_graph = [{name: '11ヶ月前', data: eleven_month_ago_time}, {name: '10ヶ月前', data: ten_month_ago_time}, {name: '9ヶ月前', data: nine_month_ago_time}, {name: '8ヶ月前', data: eight_month_ago_time}, {name: '7ヶ月前', data: seven_month_ago_time}, {name: '6ヶ月前', data: six_month_ago_time}, {name: '5ヶ月前', data: five_month_ago_time}, {name: '4ヶ月前', data: four_month_ago_time}, {name: '3ヶ月前', data: three_month_ago_time}, {name: '2ヶ月前', data: two_month_ago_time}, {name: '1ヶ月前', data: a_month_ago_time}, {name: '今月', data: this_month_time}]
    # user_channels_time_year = current_user.channel_times.where(created_at: Time.now.all_year).group(:user_channel_id).sum(:total_time)
    # @user_channels_time_year = caliculate_time(user_channels_time_year.values.sum)
  end
end

