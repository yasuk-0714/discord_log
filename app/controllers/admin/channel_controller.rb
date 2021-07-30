class Admin::ChannelController < Admin::BaseController

  def destroy
    binding.pry
    channel = Channel.find(params[:id])
    channel.destroy!
    redirect_to admin_guild_path(guild), success: 'チャンネルを削除しました'
  end
end
