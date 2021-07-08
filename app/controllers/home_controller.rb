class HomeController < ApplicationController

  def index; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    #ユーザーが参加しているチャンネルの総合時間
    @channel_time_all = current_user.channel_times.sum(:total_time)

    ChannelTime.group(:user_channel_id).pluck(:id, :user_channel_id, :total_time)
  end
end
