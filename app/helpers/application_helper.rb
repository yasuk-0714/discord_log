module ApplicationHelper
  def page_title(page_title = '', admin = false)
    base_title = if admin
                   'Discord-Log(管理画面)'
                 else
                   'Discord-Log'
                 end

    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
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

  def user_channels_time_week(user)
    user.channel_times.where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time).values.sum
  end

  def active_if(path)
    path == controller_path ? 'active' : ''
  end
end
