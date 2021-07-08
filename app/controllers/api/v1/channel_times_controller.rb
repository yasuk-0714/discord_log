class Api::V1::ChannelTimesController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    if user = User.find_by(id: params[:user_id])
      if user_channel = UserChannel.find_by(user_id: params[:user_id], channel_id: params[:channel_id])
        #退出処理
        if params[:state] == 'exit'
          update_channel = user.channel_times.last
          update_channel.update!(end_time: Time.now, total_time: Time.now - update_channel.start_time)

        #入室処理
        elsif params[:state] == 'enter'
          channel_id_list = UserChannel.where(user_id: user.id).pluck(:id)
          update_channel = ChannelTime.find_by(user_channel_id: channel_id_list, end_time: nil)

          #DiscordのカメラON・OFFや音声がON・OFFでもリクエストが飛んでしまうので、以前いたuser_channelと同じパラメーター情報であれば無視する
          if update_channel.present? && update_channel.user_channel_id == user_channel.id

          #ボイスチャンネルに入室して、退出せずに、違う部屋に入室した場合Botでは判定がつかないので、新しい入室リクエストが来たら、
          #前いたユーザーチャンネルを外部キーに持つchannel_timesテーブルのend_timeに現在時間を入れて、新たな部屋のインスタンスを生成する
          elsif update_channel
            update_channel.update(end_time: Time.now, total_time: Time.now - update_channel.start_time)
            start_channel = ChannelTime.new(start_time: Time.now, user_channel_id: user_channel.id)
            start_channel.save!

          #新規で入室した場合の処理
          else
            start_channel = ChannelTime.new(start_time: Time.now, user_channel_id: user_channel.id)
            start_channel.save!
          end
        end
      end
      redirect_to mypage_path
    end
  end
end