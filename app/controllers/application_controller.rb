class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def caliculate_time(seconds)
    hours = seconds / 3600
    mins = (seconds - 3600 * hours) / 60
    sprintf("%d時間%02d分", hours, mins)
  end
end
