User.all.each do |user|
  3.times do |n|
    a = user.guilds.seed(
      id: Faker::Number.number,
      name: Faker::JapaneseMedia::OnePiece.sea
    )
    UserGuild.seed(user_id: user.id, guild_id: a[0][:id])

    b = user.channels.seed(
      id: Faker::Number.number,
      name: Faker::JapaneseMedia::OnePiece.character,
      guild_id: a[0][:id],
      position: rand(1..50)
    )
    UserChannel.seed(user_id: user.id, channel_id: b[0][:id])
  end
end