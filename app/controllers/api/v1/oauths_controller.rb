class Api::V1::OauthsController < Api::V1::BaseController
  require 'net/http'
  require 'uri'

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path, info: t('.info')
      return
    end
    if (user = login_from(provider))
      user.authentication.update!(
        access_token: access_token.token,
        refresh_token: access_token.refresh_token
      )
    else
      fetch_user_data_from(provider)
      get_guilds
    end
    redirect_to mypage_path, success: t('.success')
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
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
    results = JSON.parse(response.body)
    results.each do |result|
      guild_id = result["id"].to_i
      guild_name = result["name"]
      #なぜかIDがguild_idで保存される
      guild = Guild.new(name: guild_name, uuid: guild_id)
      guild.save
      user_guild = UserGuild.new(user_id: current_user.id, guild_id: guild.id)
      user_guild.save
    end
  end
end
