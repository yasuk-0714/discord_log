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
    time = time_all.values.sum / 3600.0
    shaped_time = sprintf('%0.2f', time)
    @time_all['合計時間'] = shaped_time
    #ユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      time = value / 3600.0
      shaped_time = sprintf('%0.2f', time)
      @user_channels_time_all[channel.name] = shaped_time
    end

    #今日のチャンネルの使用時間
    user_channels_time_today = current_user.channel_times.where(created_at: Time.now.all_day,updated_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    @user_channels_time_today = {}
    user_channels_time_today.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      time = value / 3600.0
      shaped_time = sprintf('%0.2f', time)
      @user_channels_time_today[channel.name] = shaped_time
    end

    #今週のチャンネルの使用時間
    user_channels_time_week = current_user.channel_times.where(created_at: Time.now.all_week, updated_at: Time.now.all_week).group(:user_channel_id).sum(:total_time)
    sunday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:sunday).beginning_of_day..Time.now.beginning_of_week(:sunday).end_of_day, updated_at: Time.now.beginning_of_week(:sunday).beginning_of_day..Time.now.beginning_of_week(:sunday).end_of_day).group(:user_channel_id).sum(:total_time)
    monday =  current_user.channel_times.where(created_at: Time.now.beginning_of_week(:monday).beginning_of_day..Time.now.beginning_of_week(:monday).end_of_day, updated_at: Time.now.beginning_of_week(:monday).beginning_of_day..Time.now.beginning_of_week(:monday).end_of_day).group(:user_channel_id).sum(:total_time)
    tuesday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:tuesday).beginning_of_day..Time.now.beginning_of_week(:tuesday).end_of_day, updated_at: Time.now.beginning_of_week(:tuesday).beginning_of_day..Time.now.beginning_of_week(:tuesday).end_of_day).group(:user_channel_id).sum(:total_time)
    wednesday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:wednesday).beginning_of_day..Time.now.beginning_of_week(:wednesday).end_of_day, updated_at: Time.now.beginning_of_week(:wednesday).beginning_of_day..Time.now.beginning_of_week(:wednesday).end_of_day).group(:user_channel_id).sum(:total_time)
    thursday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:thursday).beginning_of_day..Time.now.beginning_of_week(:thursday).end_of_day, updated_at: Time.now.beginning_of_week(:thursday).beginning_of_day..Time.now.beginning_of_week(:thursday).end_of_day).group(:user_channel_id).sum(:total_time)
    friday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:friday).beginning_of_day..Time.now.beginning_of_week(:friday).end_of_day, updated_at: Time.now.beginning_of_week(:friday).beginning_of_day..Time.now.beginning_of_week(:friday).end_of_day).group(:user_channel_id).sum(:total_time)
    saturday = current_user.channel_times.where(created_at: Time.now.beginning_of_week(:saturday).beginning_of_day..Time.now.beginning_of_week(:saturday).end_of_day, updated_at: Time.now.beginning_of_week(:saturday).beginning_of_day..Time.now.beginning_of_week(:saturday).end_of_day).group(:user_channel_id).sum(:total_time)

    @sunday = []
    if sunday.keys.present?
      sunday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @sunday << ['日曜日', shaped_time]
      end
    else
      @sunday  << ['日曜日', 0]
    end

    @monday = []
    if monday.keys.present?
      monday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @monday << ['月曜日', shaped_time]
      end
    else
      @monday  << ['月曜日', 0]
    end

    @tuesday = []
    if tuesday.keys.present?
      tuesday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @tuesday << ['火曜日', shaped_time]
      end
    else
      @tuesday  << ['火曜日', 0]
    end

    @wednesday = []
    if wednesday.keys.present?
      wednesday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @wednesday << ['水曜日', shaped_time]
      end
    else
      @wednesday  << ['水曜日', 0]
    end

    @thursday = []
    if thursday.keys.present?
      thursday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @thursday << ['木曜日', shaped_time]
      end
    else
      @thursday  << ['木曜日', 0]
    end

    @friday = []
    if friday.keys.present?
      friday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @friday << ['金曜日', shaped_time]
      end
    else
      @friday << ['金曜日', 0]
    end

    @saturday = []
    if saturday.keys.present?
      saturday.map do |key, value|
        user_channel = UserChannel.find(key)
        channel = Channel.find(user_channel.channel_id)
        time = value / 3600.0
        shaped_time = sprintf('%0.2f', time)
        @saturday << ['土曜日', shaped_time]
      end
    else
      @saturday << ['土曜日', 0]
    end
    @graph = [{name: '日曜日', data: @sunday}, {name: '月曜日', data: @monday}, {name: '火曜日', data: @tuesday}, {name: '水曜日', data: @wednesday}, {name:'木曜日', data: @thursday}, {name: '金曜日', data: @friday}, {name: '土曜日', data: @saturday}]

    @user_channels_time_week = {}
    user_channels_time_week.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      time = value / 3600.0
      shaped_time = sprintf('%0.2f', time)
      @user_channels_time_week[channel.name] = shaped_time
    end
    # @user_channels_time_month = current_user.channel_times.where(created_at: Time.now.all_month, updated_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    # @user_channels_time_year = current_user.channel_times.where(created_at: Time.now.all_year, updated_at: Time.now.all_year).group(:user_channel_id).sum(:total_time)
  end
end

