
require 'discordrb'

# TOKEN = Rails.application.credentials.discrd[:token]
# CLIENT_ID = Rails.application.credentials.discord[:client_id]

bot = Discordrb::Commands::CommandBot.new(token: TOKEN,
client_id: CLIENT_ID,
prefix:'/'
)


#通知用のチャンネルID
inform_channel = ''

bot.voice_state_update do |event|
  user = event.user.name
  user_id = event.user.id
  puts "これはユーザーのIDです#{user_id}"

  #もしデータが空だと抜けていったチャンネルを取得
  if event.channel == nil then

    #チャンネル名を取得
    channel_name = event.old_channel.name
    old_channel_id = event.old_channel.id
    puts "これは前いたチャンネルのIDです#{old_channel_id}"

    #退出したことをinform_channelに通知
    #退出したときにアプリケーション側のメソッドを呼び出したい
    bot.send_message(inform_channel, "#{user}がボイスチャンネル退席: #{Time.now}")

  else
    channel_name = event.channel.name
    channel_id = event.channel.id
    puts "これはチャンネルのIDです#{channel_id}"

    #入室したときにアプリケーション側のメソッドを呼び出したい。
    #サーバー情報、ユーザー情報、チャンネル情報をDBのデータと比較して、対象のオブジェクトを呼び出して時間が計測され始めるようにする。
    bot.send_message(inform_channel, "#{user}がボイスチャンネル参加: #{channel_name} #{Time.now}" )
  end
end
bot.run