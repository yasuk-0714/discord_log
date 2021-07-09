class HomeController < ApplicationController

  def index; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    #ユーザーが参加しているチャンネルの総合時間
    @channel_time_all = current_user.channel_times.sum(:total_time)

    #ユーザーが所持しているチャンネルごとに時間を算出
    #これに日付で絞り込み検索をしたら月毎や週ごと、日毎に取得することができる
    user_channels_time = current_user.channel_times.group(:user_channel_id).sum(:total_time)
    user_channel_id_list = current_user.user_channels.where(id: user_channels_time.keys).pluck(:channel_id)
    channels = user_channel_id_list.map { |id| Channel.find(id) }
  end
end
