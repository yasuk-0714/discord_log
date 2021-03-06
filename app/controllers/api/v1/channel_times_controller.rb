class Api::V1::ChannelTimesController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    if (user = User.find_by(id: params[:user_id]))
      if (user_channel = UserChannel.find_by(user_id: params[:user_id], channel_id: params[:channel_id]))
        # 退出処理
        case params[:state]
        when 'exit'
          update_channel = user.channel_times.last
          update_channel.update!(end_time: Time.now, total_time: Time.now - update_channel.start_time)

        # 入室処理
        when 'enter'
          update_channel = user.channel_times.find_by(end_time: nil)

          # DiscordのカメラON・OFFや音声がON・OFFでもリクエストが飛んでしまうので、以前いたuser_channelと同じパラメーター情報であれば無視する
          if update_channel.present? && update_channel.user_channel_id == user_channel.id
          # ボイスチャンネルに入室して、退出せずに、違う部屋に入室した場合Botでは判定がつかないので、新しい入室リクエストが来たら、
          # 前いたユーザーチャンネルを外部キーに持つchannel_timesテーブルを更新して、新たな部屋のインスタンスを生成する
          elsif update_channel
            update_channel.update!(end_time: Time.now, total_time: Time.now - update_channel.start_time)
            ChannelTime.create!(start_time: Time.now, user_channel_id: user_channel.id)

          # 新規で入室した場合の処理
          else
            ChannelTime.create!(start_time: Time.now, user_channel_id: user_channel.id)
          end
        end
      end
      redirect_to mypage_path
    end
  end
end
