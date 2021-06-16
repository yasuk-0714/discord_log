class Api::V1::OauthsController < Api::V1::BaseController

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
    end
    redirect_to mypage_path, success: t('.success')
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def fetch_user_data_from(provider)
    user_from_provider = build_from(provider)
    binding.pry
    user = User.find_or_initialize_by(discord_id: user_from_provider.discord_id)
    @user.build_authentication(uid: @user_hash[:uid],
                               provider: provider,
                               access_token: access_token.token,
                               refresh_token: access_token.refresh_token)
    @user.save!
    reset_session
    auto_login(@user)
  end
end
