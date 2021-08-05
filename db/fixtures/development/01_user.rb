9.times do |n|
  User.seed(
    discord_id: rand(10**18),
    name: Faker::JapaneseMedia::StudioGhibli.character,
    email: Faker::Internet.email
  )
end

User.seed(discord_id: rand(10**18), name: 'admin', role: :admin, email: 'admin@example.com', crypted_password: User.encrypt('password'))