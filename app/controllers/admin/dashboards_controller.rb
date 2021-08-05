class Admin::DashboardsController < Admin::BaseController
  def index
    guild = Guild.find(Rails.application.credentials.discord[:guild_id])
    @q = guild.users.ransack(params[:q])
    @users = @q.result(distinct: true).includes(:guilds).order(:created_at).page(params[:page])
  end
end
