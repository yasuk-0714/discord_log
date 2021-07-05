class Api::V1::ChannelTimesController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    #findは例外が起きるから例外処理をする必要がある

    #アプリを登録しているユーザーかどうかを確認
    if User.find_by(id: params[:user_id])
      user_channel = UserChannel.where(user_id: params[:user_id], channel_id: params[:channel_id])
      #UserChannelsテーブルにデータが存在するか確認
      if user_channel.present?
        #退出処理
        if params[:state] == 'exit'
          end_channel = ChannelTime.where(user_channel_id: user_channel[0][:id]).last
          end_channel.update!(end_time: Time.now)

        #入室処理
        elsif params[:state] == 'enter'
          user_channels = UserChannel.where(user_id: params[:user_id])
          channel_id_list = user_channels.map { |user_channel| user_channel[:id] }
          update_channel = ChannelTime.where(user_channel_id: channel_id_list, end_time: nil)
          #DiscordのカメラON・OFFや音声がON・OFFでもリクエストが飛んでしまうので、以前いたuser_channelと同じパラメーター情報であれば無視する
          if update_channel.present? && update_channel[0][:user_channel_id] == user_channel[0][:id]

          #ボイスチャンネルに入室して、退出せずに、違う部屋に入室した場合Botでは判定がつかないので、新しい入室リクエストが来たら、
          #前いたユーザーチャンネルを外部キーに持つchannel_timesテーブルのend_timeに現在時間を入れて、新たな部屋のインスタンスを生成する
          elsif update_channel.present?
            update_channel.update(end_time: Time.now)
            start_channel = ChannelTime.new(start_time: Time.now, user_channel_id: user_channel[0][:id])
            start_channel.save!

          #新規で入室した場合の処理
          else
            start_channel = ChannelTime.new(start_time: Time.now, user_channel_id: user_channel[0][:id])
            start_channel.save!
          end
        end
      end
      redirect_to mypage_path
    end
  end
end