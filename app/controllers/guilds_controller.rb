class GuildsController < ApplicationController
  def show
    @guild = Guild.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    user_channel = current_user.user_channels.where(channel_id: @guild.channels.ids).pluck(:id)

    #これまでのサーバー内のチャンネル使用時間を計算
    guild_time = ChannelTime.where(user_channel_id: user_channel).sum(:total_time)
    #時間表示用
    @guild_time = caliculate_time(guild_time)
    #グラフ表示用
    @guild_time_graph = {}
    @guild_time_graph['合計時間'] = shaped_time(guild_time)
    #サーバー内のこれまでのチャンネル使用時間トップ5を算出
    guild_time_all = ChannelTime.where(user_channel_id: user_channel).group(:user_channel_id).sum(:total_time)
    guild_time_each = guild_time_all.sort_by {|k,v| v}.reverse.first(5).to_h
    @guild_time_each_channel = {}
    guild_time_each.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @guild_time_each_channel[channel.name] = shaped_time
    end

    #今日のチャンネル使用時間が算出される
    guild_time_today = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).sum(:total_time)
    #時間表示用
    @guild_time_today = caliculate_time(guild_time_today)
    #グラフ用
    @guild_time_today_graph = {}
    @guild_time_today_graph[@guild.name] = shaped_time(guild_time_today)
    #本日のサーバー内のチャンネル使用時間トップ5を算出
    guild_time_today_all = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    guild_time_today_each = guild_time_today_all.sort_by {|k,v| v}.reverse.first(5).to_h
    @guild_time_today_each_channel = {}
    guild_time_today_each.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @guild_time_today_each_channel[channel.name] = shaped_time
    end

    #今日から６日前までの使用時間
    guild_time_week = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).sum(:total_time)
    #時間表示用
    @guild_time_week = caliculate_time(guild_time_week)
    #グラフ用
    on_day = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).sum(:total_time)
    day_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.yesterday.beginning_of_day..Time.now.yesterday.end_of_day).sum(:total_time)
    two_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.days.ago.beginning_of_day..2.days.ago.end_of_day).sum(:total_time)
    three_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.days.ago.beginning_of_day..3.days.ago.end_of_day).sum(:total_time)
    four_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.days.ago.beginning_of_day..4.days.ago.end_of_day).sum(:total_time)
    five_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.days.ago.beginning_of_day..5.days.ago.end_of_day).sum(:total_time)
    six_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.beginning_of_day..6.days.ago.end_of_day).sum(:total_time)
    on_day = [['今日', shaped_time(on_day)]]
    day_ago = [['１日前', shaped_time(day_ago)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago)]]
    @weeks_graph = [{name: '6日前', data: six_days_ago}, {name: '５日前', data: five_days_ago}, {name: '４日前', data: four_days_ago},
                    {name:'３日前', data: three_days_ago}, {name: '２日前', data: two_days_ago}, {name: '１日前', data: day_ago}, {name: '今日', data: on_day}]
    #今日から6日前までのサーバー内のチャンネル使用時間トップ5を算出
    guild_time_week_all = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    guild_time_week_each = guild_time_week_all.sort_by {|k,v| v}.reverse.first(5).to_h
    @guild_time_week_each_channel = {}
    guild_time_week_each.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @guild_time_week_each_channel[channel.name] = shaped_time
    end

    #今月のチャンネル使用時間
    guild_time_month = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_month).sum(:total_time)
    #時間表示用
    @guild_time_month = caliculate_time(guild_time_month)

    #数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:total_time)
    two_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.month.ago.beginning_of_month..2.month.ago.end_of_month).sum(:total_time)
    three_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.month.ago.beginning_of_month..3.month.ago.end_of_month).sum(:total_time)
    four_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.month.ago.beginning_of_month..4.month.ago.end_of_month).sum(:total_time)
    five_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.month.ago.beginning_of_month..5.month.ago.end_of_month).sum(:total_time)
    six_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.month.ago.beginning_of_month..6.month.ago.end_of_month).sum(:total_time)
    seven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 7.month.ago.beginning_of_month..7.month.ago.end_of_month).sum(:total_time)
    eight_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 8.month.ago.beginning_of_month..8.month.ago.end_of_month).sum(:total_time)
    nine_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 9.month.ago.beginning_of_month..9.month.ago.end_of_month).sum(:total_time)
    ten_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 10.month.ago.beginning_of_month..10.month.ago.end_of_month).sum(:total_time)
    eleven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 11.month.ago.beginning_of_month..11.month.ago.end_of_month).sum(:total_time)
    this_month_time = [['今月', shaped_time(guild_time_month)]]
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
    @months_graph = [{name: '11ヶ月前', data: eleven_month_ago_time}, {name: '10ヶ月前', data: ten_month_ago_time}, {name: '9ヶ月前', data: nine_month_ago_time},
                      {name: '8ヶ月前', data: eight_month_ago_time}, {name: '7ヶ月前', data: seven_month_ago_time}, {name: '6ヶ月前', data: six_month_ago_time},
                      {name: '5ヶ月前', data: five_month_ago_time}, {name: '4ヶ月前', data: four_month_ago_time}, {name: '3ヶ月前', data: three_month_ago_time},
                      {name: '2ヶ月前', data: two_month_ago_time}, {name: '1ヶ月前', data: a_month_ago_time}, {name: '今月', data: this_month_time}]
  end
end
