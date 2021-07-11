class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  #画面表示用
  def caliculate_time(seconds)
    hours = seconds / 3600
    mins = (seconds - 3600 * hours) / 60
    sprintf("%d時間%02d分", hours, mins)
  end

  #グラフ用
  def shaped_time(seconds)
    time = seconds / 3600.0
    sprintf('%0.2f', time)
  end
end
