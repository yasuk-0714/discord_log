class Admin::GuildsController < Admin::BaseController
  before_action :set_guild, only: %i[show destroy]

  def index
    @q = Guild.ransack(params[:q])
    @guilds = @q.result(distinct: true).order(:created_at).page(params[:page])
  end

  def show
    @channels = @guild.channels.order(:position)
    @users = @guild.users
  end

  def destroy
    @guild.destroy!
    redirect_to admin_guilds_path, success: 'サーバーを削除しました'
  end

  private

  def set_guild
    @guild = Guild.find_by(uuid: params[:uuid])
  end
end
