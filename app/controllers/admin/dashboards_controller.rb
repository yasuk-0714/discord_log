class Admin::DashboardsController < Admin::BaseController
  def index
    guild = Guild.find(Rails.application.credentials.discord[:guild_id])
    @guild_users = guild.users
  end
end
