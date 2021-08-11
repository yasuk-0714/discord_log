class Api::V1::OauthsController < Api::V1::BaseController
  require 'net/http'
  require 'uri'

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    begin
      if (user = login_from(provider))
        user.authentication.update!(
          access_token: access_token.token,
          refresh_token: access_token.refresh_token
        )
        user.update!(name: @user_hash[:user_info]['username'],
                     email: @user_hash[:user_info]['email'])
      else
        fetch_user_data_from(provider)
      end
      token = access_token.token
      get_guilds(token)
      get_channels
      redirect_to mypage_path
    rescue StandardError
      redirect_to root_path, info: t('.info')
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def fetch_user_data_from(provider)
    build_from(provider)
    @user.build_authentication(uid: @user_hash[:uid],
                               provider: provider,
                               access_token: access_token.token,
                               refresh_token: access_token.refresh_token)
    @user.save!
    reset_session
    auto_login(@user)
  end

  def get_guilds(token)
    uri = URI.parse('https://discord.com/api/v8/users/@me/guilds')
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
      guild_id = result['id'].to_i
      guild_name = result['name']
      guild = Guild.find_or_initialize_by(id: guild_id, name: guild_name, uuid: guild_id)
      unless guild.save
        guild = Guild.find(guild_id)
        guild.update(name: guild_name)
      end
      current_user.user_guilds.find_or_create_by(guild_id: guild.id)
      @guild_list.delete_if { |n| n == guild_id }
    end
    destroy_guilds = UserGuild.where(guild_id: @guild_list)
    destroy_guilds.each(&:destroy)
  end

  def get_channels
    guilds = current_user.guilds.ids
    @channel_list = current_user.channels.ids
    guilds.each do |guild|
      uri = URI.parse('https://discord.com')
      uri.path = "/api/v8/guilds/#{guild}/widget.json"
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      response = https.get uri.request_uri
      response_hash = JSON.parse(response.body)
      response_hash['channels'].each do |value|
        channel_id = value['id'].to_i
        channel_name = value['name']
        channel_position = value['position']
        channel = Channel.find_or_initialize_by(id: channel_id, name: channel_name, uuid: channel_id, position: channel_position, guild_id: guild)
        unless channel.save
          channel = Channel.find(channel_id)
          channel.update(name: channel_name, position: channel_position)
        end
        current_user.user_channels.find_or_create_by(channel_id: channel_id)
        @channel_list.delete_if { |n| n == channel_id }
      end
    rescue StandardError => e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
    destroy_channels = UserChannel.where(channel_id: @channel_list)
    destroy_channels.each(&:destroy)
  end
end
