class HomeController < ApplicationController

  def index; end

  def mypage
    @guilds = current_user.guilds
  end
end
