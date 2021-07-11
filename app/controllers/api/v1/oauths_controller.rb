class Api::V1::OauthsController < Api::V1::BaseController
  require 'net/http'
  require 'uri'

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path
      return
    end
    begin
      if (user = login_from(provider))
        user.authentication.update!(
          access_token: access_token.token,
          refresh_token: access_token.refresh_token)
      else
        fetch_user_data_from(provider)
      end
      get_guilds
      get_channels
      redirect_to mypage_path
    rescue
      redirect_to root_path, info: 'ログインをキャンセルしました'
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def fetch_user_data_from(provider)
    user_from_provider = build_from(provider)
    user = User.find_or_initialize_by(discord_id: user_from_provider.discord_id)
    @user.build_authentication(uid: @user_hash[:uid],
                               provider: provider,
                               access_token: access_token.token,
                               refresh_token: access_token.refresh_token)
    @user.save!
    reset_session
    auto_login(@user)
  end

  def get_guilds
    token = current_user.authentication.access_token
    uri = URI.parse("https://discord.com/api/v8/users/@me/guilds")
    req = Net::HTTP::Get.new(uri)
    req['authorization'] = "Bearer #{token}"
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    @guild_list = current_user.guilds.ids
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
    results = JSON.parse(response.body)
    results.each do |result|
      guild_id = result["id"].to_i
      guild_name = result["name"]
      guild = Guild.find_or_initialize_by(id: guild_id, name: guild_name, uuid: guild_id)
      unless guild.save
        guild = Guild.find_by(id: guild_id)
        guild.update(name: guild_name)
      end
      user_guild = current_user.user_guilds.find_or_initialize_by(guild_id: guild.id)
      user_guild.save
      @guild_list.delete_if { |n| n == guild_id }
    end
    destroy_guilds = UserGuild.where(guild_id: @guild_list)
    destroy_guilds.each do |guild|
      guild.destroy
    end
  end

  def get_channels
    guilds = []
    current_user.guilds.each do |result|
      guilds << result[:id]
    end
    @channel_list = current_user.channels.ids
    guilds.each do |guild|
      begin
        uri = URI.parse("https://discord.com")
        uri.path = "/api/v8/guilds/#{guild}/widget.json"
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        response = https.get uri.request_uri
        response_hash = JSON.parse(response.body)
        response_hash["channels"].each do |value|
          id = value['id'].to_i
          name = value['name']
          position = value['position']
          channel = Channel.find_or_initialize_by(id: id, name: name, uuid: id, position: position, guild_id: guild)
          unless channel.save
            channel = Channel.find_by(id: id)
            channel.update(name: name, position: position)
          end
          user_channel = current_user.user_channels.find_or_initialize_by(channel_id: id)
          user_channel.save
          @channel_list.delete_if { |n| n ==id }
        end
      rescue => e
        puts "#{e.class}, #{e.message}"
      end
    end
    destroy_channels = UserChannel.where(channel_id: @channel_list)
    destroy_channels.each do |channel|
      channel.destroy
    end
  end
end
