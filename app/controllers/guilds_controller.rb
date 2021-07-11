class GuildsController < ApplicationController
  def show
    @guild = Guild.find_by(uuid: params[:uuid])
    @guilds = current_user.guilds
    @channels = current_user.channels.order(position: :asc).map {|user_channel| user_channel }
  end
end
