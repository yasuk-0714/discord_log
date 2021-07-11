class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login, only: :mypage

  #画面表示用
  def caliculate_time(seconds)
    if seconds
      hours = seconds / 3600
      mins = (seconds - 3600 * hours) / 60
      sprintf("%d時間 %02d分", hours, mins)
    else
      sprintf("%d時間 %02d分", 0, 0)
    end
  end

  #グラフ用
  def shaped_time(seconds)
    if seconds
      time = seconds / 3600.0
      sprintf('%0.2f', time)
    else
      sprintf('%0.2f', 0)
    end
  end

  private

  def not_authenticated
    redirect_to root_path, danger: 'ログインしてください'
  end
end
