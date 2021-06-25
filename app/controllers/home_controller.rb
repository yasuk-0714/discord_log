class HomeController < ApplicationController

  def index; end

  def mypage
    @guilds = current_user.guilds
    @guild_channels = []
    @guilds.each do |guild|
      if guild.channels.exists?
        @guild_channels << guild.channels
      end
    end
    @channels = @guild_channels.flatten
  end
end
