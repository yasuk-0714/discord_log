class Admin::ChannelsController < Admin::BaseController
  def destroy
    channel = Channel.find(params[:id])
    channel.destroy!
    redirect_back(fallback_location: admin_guilds_path)
    flash[:success] = t('.success')
  end
end
