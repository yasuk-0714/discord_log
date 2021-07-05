class HomeController < ApplicationController

  def index; end

  def mypage
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }

    user_channels = UserChannel.where(user_id: current_user.id)
    channel_time = ChannelTime.where(user_channel_id: user_channels.ids)
  end
end
