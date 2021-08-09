class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login, only: [:mypage]

  rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_500(error)
    logger.error(error.message)
    logger.error(error.backtrace.join("\n"))
    render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  end

  private

  def not_authenticated
    redirect_to root_path, danger: t('defaults.message.login_required')
  end

  # 画面表示用
  def caliculate_time(seconds)
    if seconds
      hours = seconds / 3600
      mins = (seconds - 3600 * hours) / 60
      format('%d時間 %02d分', hours, mins)
    else
      format('%d時間 %02d分', 0, 0)
    end
  end

  # グラフ用
  def shaped_time(seconds)
    if seconds
      time = seconds / 3600.0
      format('%0.2f', time)
    else
      format('%0.2f', 0)
    end
  end
end
