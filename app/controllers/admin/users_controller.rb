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
    on_day = @user.channel_times.date(Time.now.all_day).total_time
    day_ago = @user.channel_times.date(1.day.ago.all_day).total_time
    two_days_ago = @user.channel_times.date(2.days.ago.all_day).total_time
    three_days_ago = @user.channel_times.date(3.days.ago.all_day).total_time
    four_days_ago = @user.channel_times.date(4.days.ago.all_day).total_time
    five_days_ago = @user.channel_times.date(5.days.ago.all_day).total_time
    six_days_ago = @user.channel_times.date(6.days.ago.all_day).total_time
    on_day = [['今日', shaped_time(on_day)]]
    day_ago = [['１日前', shaped_time(day_ago)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago)]]
    five_days_ago = [['5日前', shaped_time(five_days_ago)]]
    six_days_ago = [['6日前', shaped_time(six_days_ago)]]
    @all_time_past_week_graph = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
                                 { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: on_day }]
    # チャンネル使用時間トップ5を算出
    rank_sort = all_time_past_week.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_past_week_rank = {})

    # 7日前から13日前までのチャンネルの使用時間
    all_time_last_2weeks = @user.channel_times.date(13.days.ago.beginning_of_day..7.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_2weeks = caliculate_time(all_time_last_2weeks.values.sum)
    # グラフ用
    seven_days_ago = @user.channel_times.date(7.days.ago.all_day).total_time
    eight_days_ago = @user.channel_times.date(8.days.ago.all_day).total_time
    nine_days_ago =  @user.channel_times.date(9.days.ago.all_day).total_time
    ten_days_ago = @user.channel_times.date(10.days.ago.all_day).total_time
    eleven_days_ago = @user.channel_times.date(11.days.ago.all_day).total_time
    twelve_days_ago = @user.channel_times.date(12.days.ago.all_day).total_time
    thirteen_days_ago = @user.channel_times.date(13.days.ago.all_day).total_time
    seven_days_ago = [['7日前', shaped_time(seven_days_ago)]]
    eight_days_ago = [['8日前', shaped_time(eight_days_ago)]]
    nine_days_ago = [['9日前', shaped_time(nine_days_ago)]]
    ten_days_ago = [['10日前', shaped_time(ten_days_ago)]]
    eleven_days_ago = [['11日前', shaped_time(eleven_days_ago)]]
    twelve_days_ago = [['12日前', shaped_time(twelve_days_ago)]]
    thirteen_days_ago = [['13日前', shaped_time(thirteen_days_ago)]]
    @all_time_last_2weeks_graph = [{ data: thirteen_days_ago }, { data: twelve_days_ago }, { data: eleven_days_ago },
                                   { data: ten_days_ago }, { data: nine_days_ago }, { data: eight_days_ago }, { data: seven_days_ago }]
    # チャンネル使用時間トップ5を算出
    rank_sort = all_time_last_2weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_2weeks_rank = {})

    # 14日前から20日前までのチャンネルの使用時間
    all_time_last_3weeks = @user.channel_times.date(20.days.ago.beginning_of_day..14.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_3weeks = caliculate_time(all_time_last_3weeks.values.sum)
    # グラフ用
    fourteen_days_ago = @user.channel_times.date(14.days.ago.all_day).total_time
    fifteen_days_ago = @user.channel_times.date(15.days.ago.all_day).total_time
    sixteen_days_ago = @user.channel_times.date(16.days.ago.all_day).total_time
    seventeen_days_ago = @user.channel_times.date(17.days.ago.all_day).total_time
    eighteen_days_ago = @user.channel_times.date(18.days.ago.all_day).total_time
    nineteen_days_ago = @user.channel_times.date(19.days.ago.all_day).total_time
    twenty_days_ago = @user.channel_times.date(20.days.ago.all_day).total_time
    fourteen_days_ago = [['14日前', shaped_time(fourteen_days_ago)]]
    fifteen_days_ago = [['15日前', shaped_time(fifteen_days_ago)]]
    sixteen_days_ago = [['16日前', shaped_time(sixteen_days_ago)]]
    seventeen_days_ago = [['17日前', shaped_time(seventeen_days_ago)]]
    eighteen_days_ago = [['18日前', shaped_time(eighteen_days_ago)]]
    nineteen_days_ago = [['19日前', shaped_time(nineteen_days_ago)]]
    twenty_days_ago = [['20日前', shaped_time(twenty_days_ago)]]
    @all_time_last_3weeks_graph = [{ data: twenty_days_ago }, { data: nineteen_days_ago }, { data: eighteen_days_ago },
                                   { data: seventeen_days_ago }, { data: sixteen_days_ago }, { data: fifteen_days_ago }, { data: fourteen_days_ago }]
    # チャンネルの使用時間トップ5を算出
    rank_sort = all_time_last_3weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_3weeks_rank = {})

    # 21日前から27日前までのチャンネルの使用時間
    all_time_last_4weeks = @user.channel_times.date(27.days.ago.beginning_of_day..21.days.ago.end_of_day).group_id.total_time
    # 時間表示用
    @all_time_last_4weeks = caliculate_time(all_time_last_4weeks.values.sum)
    # グラフ用
    twentyone_days_ago = @user.channel_times.date(21.days.ago.all_day).total_time
    twentytwo_days_ago = @user.channel_times.date(22.days.ago.all_day).total_time
    twentythree_days_ago = @user.channel_times.date(23.days.ago.all_day).total_time
    twentyfour_days_ago = @user.channel_times.date(24.days.ago.all_day).total_time
    twentyfive_days_ago = @user.channel_times.date(25.days.ago.all_day).total_time
    twentysix_days_ago = @user.channel_times.date(26.days.ago.all_day).total_time
    twentyseven_days_ago = @user.channel_times.date(27.days.ago.all_day).total_time
    twentyone_days_ago = [['21日前', shaped_time(twentyone_days_ago)]]
    twentytwo_days_ago = [['22日前', shaped_time(twentytwo_days_ago)]]
    twentythree_days_ago = [['23日前', shaped_time(twentythree_days_ago)]]
    twentyfour_days_ago = [['24日前', shaped_time(twentyfour_days_ago)]]
    twentyfive_days_ago = [['25日前', shaped_time(twentyfive_days_ago)]]
    twentysix_days_ago = [['26日前', shaped_time(twentysix_days_ago)]]
    twentyseven_days_ago = [['27日前', shaped_time(twentyseven_days_ago)]]
    @all_time_last_4weeks_graph = [{ data: twentyseven_days_ago }, { data: twentysix_days_ago }, { data: twentyfive_days_ago },
                                   { data: twentyfour_days_ago }, { data: twentythree_days_ago }, { data: twentytwo_days_ago }, { data: twentyone_days_ago }]
    # チャンネルの使用時間トップ5
    rank_sort = all_time_last_4weeks.sort_by { |_key, value| value }.reverse.first(5).to_h
    top_five_channel_times(rank_sort, @all_time_last_4weeks_rank = {})

    # 今月のチャンネル使用時間
    all_time_this_month = @user.channel_times.date(Time.now.all_month).total_time
    # 時間表示用
    @all_time_this_month = caliculate_time(all_time_this_month)
    # グラフ用
    a_month_ago = @user.channel_times.date(1.month.ago.all_month).total_time
    two_month_ago = @user.channel_times.date(2.months.ago.all_month).total_time
    three_month_ago = @user.channel_times.date(3.months.ago.all_month).total_time
    four_month_ago = @user.channel_times.date(4.months.ago.all_month).total_time
    five_month_ago = @user.channel_times.date(5.months.ago.all_month).total_time
    six_month_ago = @user.channel_times.date(6.months.ago.all_month).total_time
    seven_month_ago = @user.channel_times.date(7.months.ago.all_month).total_time
    eight_month_ago = @user.channel_times.date(8.months.ago.all_month).total_time
    nine_month_ago = @user.channel_times.date(9.months.ago.all_month).total_time
    ten_month_ago = @user.channel_times.date(10.months.ago.all_month).total_time
    eleven_month_ago = @user.channel_times.date(11.months.ago.all_month).total_time
    this_month_time = [['今月', shaped_time(all_time_this_month)]]
    a_month_ago_time = [['1ヶ月前', shaped_time(a_month_ago)]]
    two_month_ago_time = [['2ヶ月前', shaped_time(two_month_ago)]]
    three_month_ago_time = [['3ヶ月前', shaped_time(three_month_ago)]]
    four_month_ago_time = [['4ヶ月前', shaped_time(four_month_ago)]]
    five_month_ago_time = [['5ヶ月前', shaped_time(five_month_ago)]]
    six_month_ago_time = [['6ヶ月前', shaped_time(six_month_ago)]]
    seven_month_ago_time = [['7ヶ月前', shaped_time(seven_month_ago)]]
    eight_month_ago_time = [['8ヶ月前', shaped_time(eight_month_ago)]]
    nine_month_ago_time = [['9ヶ月前', shaped_time(nine_month_ago)]]
    ten_month_ago_time = [['10ヶ月前', shaped_time(ten_month_ago)]]
    eleven_month_ago_time = [['11ヶ月前', shaped_time(eleven_month_ago)]]
    @all_time_months_graph = [{ data: eleven_month_ago_time }, { data: ten_month_ago_time }, { data: nine_month_ago_time },
                              { data: eight_month_ago_time }, { data: seven_month_ago_time }, { data: six_month_ago_time },
                              { data: five_month_ago_time }, { data: four_month_ago_time }, { data: three_month_ago_time },
                              { data: two_month_ago_time }, { data: a_month_ago_time }, { data: this_month_time }]
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
      shaped_time = caliculate_time(value)
      hash_container[channel.name] = shaped_time
    end
  end

  def sort_time_for_each_channel(channel_sort, hash_container)
    channel_sort.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      hash_container[channel.name] = shaped_time
    end
  end
end
