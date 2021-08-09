class ChannelsController < ApplicationController
  def show
    @channel = Channel.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map { |user_channel| user_channel }

    user_channel = current_user.user_channels.where(channel_id: @channel.id).pluck(:id)

    # 今までのチャンネルの使用時間が算出される
    channel_time = ChannelTime.where(user_channel_id: user_channel).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @channel_time = caliculate_time(channel_time.values[0])
    # グラフ
    @channel_time_graph = {}
    @channel_time_graph[t('defaults.common.total_time')] = shaped_time(channel_time.values[0])

    # 今日のチャンネル使用時間が算出される
    channel_time_today = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @channel_time_today = caliculate_time(channel_time_today.values[0])
    # グラフ用
    @channel_time_today_graph = {}
    @channel_time_today_graph[@channel.name] = shaped_time(channel_time_today.values[0])

    # 今日から6日前までの使用時間
    channel_time_week = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @channel_time_week = caliculate_time(channel_time_week.values[0])
    # グラフ用
    on_day = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [[t('defaults.day.today'), shaped_time(on_day.values.sum)]]
    day_ago = [[t('defaults.day.1_day_ago'), shaped_time(day_ago.values.sum)]]
    two_days_ago = [[t('defaults.day.2_days_ago'), shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [[t('defaults.day.3_days_ago'), shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [[t('defaults.day.4_days_ago'), shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [[t('defaults.day.5_days_ago'), shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [[t('defaults.day.6_days_ago'), shaped_time(six_days_ago.values.sum)]]
    @weeks_graph = [{ name: t('defaults.day.6_days_ago'), data: six_days_ago }, { name: t('defaults.day.5_days_ago'), data: five_days_ago }, { name: t('defaults.day.4_days_ago'), data: four_days_ago },
                    { name: t('defaults.day.3_days_ago'), data: three_days_ago }, { name: t('defaults.day.2_days_ago'), data: two_days_ago }, { name: t('defaults.day.1_day_ago'), data: day_ago }, { name: t('defaults.day.today'), data: on_day }]

    # 今月のチャンネル使用時間
    channel_time_month = ChannelTime.where(user_channel_id: user_channel).where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @channel_time_month = caliculate_time(channel_time_month.values[0])

    # 数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = ChannelTime.where(user_channel_id: user_channel).where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [[t('defaults.month.this_month'), shaped_time(channel_time_month.values.sum)]]
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
    @months_graph = [{ name: t('defaults.month.11_months_ago'), data: eleven_month_ago_time }, { name: t('defaults.month.10_months_ago'), data: ten_month_ago_time }, { name: t('defaults.month.9_months_ago'), data: nine_month_ago_time },
                     { name: t('defaults.month.8_months_ago'), data: eight_month_ago_time }, { name: t('defaults.month.7_months_ago'), data: seven_month_ago_time }, { name: t('defaults.month.6_months_ago'), data: six_month_ago_time },
                     { name: t('defaults.month.5_months_ago'), data: five_month_ago_time }, { name: t('defaults.month.4_months_ago'), data: four_month_ago_time }, { name: t('defaults.month.3_months_ago'), data: three_month_ago_time },
                     { name: t('defaults.month.2_months_ago'), data: two_month_ago_time }, { name: t('defaults.month.1_month_ago'), data: a_month_ago_time }, { name: t('defaults.month.this_month'), data: this_month_time }]
  end
end
