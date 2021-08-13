class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(:created_at).page(params[:page])
  end

  def show
    @user = User.find_by(uuid: params[:uuid])
    @guilds = @user.guilds
    @channels = @user.channels.order(:position).map { |channel| channel }

    # これまでユーザーが使用したボイスチャンネルの使用時間
    all_time_so_far = @user.channel_times.group_id.total_time
    # 時間表示用
    @all_time_so_far = caliculate_time(all_time_so_far.values.sum)
    # グラフ用
    @all_time_so_far_graph = {}
    @all_time_so_far_graph['合計'] = shaped_time(all_time_so_far.values.sum)
    # チャンネルの使用時間トップ5を算出
    rank_sort = all_time_so_far.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_so_far_rank = {})

    # 各チャンネルそれぞれの使用時間グラフ
    channel_sort = all_time_so_far.sort_by { |_key, value| value }.reverse.to_h
    sort_time_for_each_channel(channel_sort, @time_for_each_channel_graph = {})

    # ここ１週間のチャンネル使用時間
    all_time_past_week = @user.channel_times.date(6.days.ago.beginning_of_day..Time.now.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_past_week = caliculate_time(all_time_past_week.values.sum)
    # グラフ用
    @all_time_past_week_graph = all_time_past_week_graph(0, 6)
    # チャンネル使用時間トップ5を算出
    rank_sort = all_time_past_week.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_past_week_rank = {})

    # 7日前から13日前までのチャンネルの使用時間
    all_time_last_2weeks = @user.channel_times.date(13.days.ago.beginning_of_day..7.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_2weeks = caliculate_time(all_time_last_2weeks.values.sum)
    # グラフ用
    @all_time_last_2weeks_graph = all_time_past_week_graph(7, 13)
    # チャンネル使用時間トップ5を算出
    rank_sort = all_time_last_2weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_2weeks_rank = {})

    # 14日前から20日前までのチャンネルの使用時間
    all_time_last_3weeks = @user.channel_times.date(20.days.ago.beginning_of_day..14.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_3weeks = caliculate_time(all_time_last_3weeks.values.sum)
    # グラフ用
    @all_time_last_3weeks_graph = all_time_past_week_graph(14, 20)
    # チャンネルの使用時間トップ5を算出
    rank_sort = all_time_last_3weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_3weeks_rank = {})

    # 21日前から27日前までのチャンネルの使用時間
    all_time_last_4weeks = @user.channel_times.date(27.days.ago.beginning_of_day..21.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_4weeks = caliculate_time(all_time_last_4weeks.values.sum)
    # グラフ用
    @all_time_last_4weeks_graph = all_time_past_week_graph(21, 27)
    # チャンネルの使用時間トップ5
    rank_sort = all_time_last_4weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_4weeks_rank = {})

    # 今月のチャンネル使用時間
    all_time_this_month = @user.channel_times.date(Time.now.all_month).total_time
    # 時間表示用
    @all_time_this_month = caliculate_time(all_time_this_month)
    # グラフ用
    @all_time_months_graph = (0..11).to_a.reverse.map do |month|
      month_time = @user.channel_times.date(month.month.ago.all_month).total_time
      {data: [[month.zero? ? '今月' : "#{month}ヶ月前", shaped_time(month_time)]]}
    end

  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_root_path, success: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_back(fallback_location: admin_root_path)
    flash[:success] = t('.success')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :password, :password_confirmation)
  end

  def top_five_channel_times(rank_sort, hash_container)
    rank_sort.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      hash_container[channel.name] = caliculate_time(value)
    end
  end

  def sort_time_for_each_channel(channel_sort, hash_container)
    channel_sort.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      hash_container[channel.name] = shaped_time(value)
    end
  end

  def all_time_past_week_graph(i, n)
    container = (i..n).to_a.reverse.map do |day|
      day_time = @user.channel_times.date(day.day.ago.all_day).total_time
      { data: [[day.zero? ? '今日' : "#{day}日前", shaped_time(day_time)]] }
    end
  end

end
