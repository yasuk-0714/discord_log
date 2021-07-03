class Api::V1::ChannelTimesController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    #findは例外が起きるから例外処理をする必要がある
    if User.find_by(id: params[:user_id])

      user_channel = UserChannel.where(user_id: params[:user_id], channel_id: params[:channel_id])
      if ChannelTime.where(user_channel_id: user_channel[0][:id], end_time: nil).present?
        end_time = ChannelTime.where(user_channel_id: user_channel[0][:id]).last
        end_time.update(end_time: Time.now)
      elsif ChannelTime.where(user_channel_id: user_channel[0][:id]).present? || ChannelTime.where(user_channel_id: user_channel[0][:id]).none?
        user_channels = UserChannel.where(user_id: params[:user_id])
        channel_id_list = user_channels.map { |user_channel| user_channel[:id] }
        update_channel = ChannelTime.where(user_channel_id: channel_id_list, end_time: nil)
        if update_channel.present?
          update_channel.update(end_time: Time.now)
        end
        start_time = ChannelTime.new(start_time: Time.now, user_channel_id: user_channel[0][:id])
        start_time.save
      end

      redirect_to mypage_path
    end
  end
end