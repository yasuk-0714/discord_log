class Admin::DashboardsController < Admin::BaseController
  def index
    guild = Guild.find(Rails.application.credentials.discord[:guild_id])
    @users = guild.users.order(:created_at).page(params[:page])
  end
end
