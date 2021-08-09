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

    # ユーザーが所持しているチャンネルごとに時間を算出
    time_all = @user.channel_times.group(:user_channel_id).sum(:total_time)

    # ユーザーが参加しているチャンネルの総合時間 :表示用
    @total_time = caliculate_time(time_all.values.sum)
    # ユーザーが参加しているチャンネルの総合時間 :グラフ用
    @time_all = {}
    @time_all[t('defaults.common.total_time')] = shaped_time(time_all.values.sum)

    # 全てのユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_all = time_all.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_all = {}
    user_channel_time_each_all.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_all[channel.name] = shaped_time
    end

    # これまでのユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.sort_by { |key, value| value }.reverse.to_h.each do |key, value|
      user_channel = UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_all[channel.name] = shaped_time
    end

    # 今日から６日前までのチャンネルの使用時間
    user_channels_time_week = @user.channel_times.where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_week = caliculate_time(user_channels_time_week.values.sum)
    # グラフ用
    on_day = @user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = @user.channel_times.where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago = @user.channel_times.where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = @user.channel_times.where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = @user.channel_times.where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = @user.channel_times.where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = @user.channel_times.where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [[t('defaults.day.today'), shaped_time(on_day.values.sum)]]
    day_ago = [[t('defaults.day.1_day_ago'), shaped_time(day_ago.values.sum)]]
    two_days_ago = [[t('defaults.day.2_days_ago'), shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [[t('defaults.day.3_days_ago'), shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [[t('defaults.day.4_days_ago'), shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [[t('defaults.day.5_days_ago'), shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [[t('defaults.day.6_days_ago'), shaped_time(six_days_ago.values.sum)]]
    @graph_week = [{ data: six_days_ago }, { data: five_days_ago }, { data: four_days_ago },
                   { data: three_days_ago }, { data: two_days_ago }, { data: day_ago }, { data: on_day }]
    # 今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_week = user_channels_time_week.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_week = {}
    user_channel_time_each_week.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_week[channel.name] = shaped_time
    end

    # 7日前から13日前までのチャンネルの使用時間
    user_channels_time_2week = @user.channel_times.where(created_at: 13.days.ago.beginning_of_day..7.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_2week = caliculate_time(user_channels_time_2week.values.sum)
    # グラフ用
    seven_days_ago = @user.channel_times.where(created_at: 7.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eight_days_ago = @user.channel_times.where(created_at: 8.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    nine_days_ago =  @user.channel_times.where(created_at: 9.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    ten_days_ago = @user.channel_times.where(created_at: 10.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eleven_days_ago = @user.channel_times.where(created_at: 11.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twelve_days_ago = @user.channel_times.where(created_at: 12.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    thirteen_days_ago = @user.channel_times.where(created_at: 13.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    seven_days_ago = [[t('defaults.day.7_days_ago'), shaped_time(seven_days_ago.values.sum)]]
    eight_days_ago = [[t('defaults.day.8_days_ago'), shaped_time(eight_days_ago.values.sum)]]
    nine_days_ago = [[t('defaults.day.9_days_ago'), shaped_time(nine_days_ago.values.sum)]]
    ten_days_ago = [[t('defaults.day.10_days_ago'), shaped_time(ten_days_ago.values.sum)]]
    eleven_days_ago = [[t('defaults.day.11_days_ago'), shaped_time(eleven_days_ago.values.sum)]]
    twelve_days_ago = [[t('defaults.day.12_days_ago'), shaped_time(twelve_days_ago.values.sum)]]
    thirteen_days_ago = [[t('defaults.day.13_days_ago'), shaped_time(thirteen_days_ago.values.sum)]]
    @graph_2week = [{ data: thirteen_days_ago }, { data: twelve_days_ago }, { data: eleven_days_ago },
                    { data: ten_days_ago }, { data: nine_days_ago }, { data: eight_days_ago }, { data: seven_days_ago }]

    # 7日前から13日前までの使用時間トップ5を算出
    user_channel_time_each_2week = user_channels_time_2week.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_2week = {}
    user_channel_time_each_2week.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_2week[channel.name] = shaped_time
    end

    # 14日前から20日前までのチャンネルの使用時間
    user_channels_time_3week = @user.channel_times.where(created_at: 20.days.ago.beginning_of_day..14.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_3week = caliculate_time(user_channels_time_3week.values.sum)
    # グラフ用
    fourteen_days_ago = @user.channel_times.where(created_at: 14.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    fifteen_days_ago = @user.channel_times.where(created_at: 15.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    sixteen_days_ago = @user.channel_times.where(created_at: 16.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    seventeen_days_ago = @user.channel_times.where(created_at: 17.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eighteen_days_ago = @user.channel_times.where(created_at: 18.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    nineteen_days_ago = @user.channel_times.where(created_at: 19.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twenty_days_ago = @user.channel_times.where(created_at: 20.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    fourteen_days_ago = [[t('defaults.day.14_days_ago'), shaped_time(fourteen_days_ago.values.sum)]]
    fifteen_days_ago = [[t('defaults.day.15_days_ago'), shaped_time(fifteen_days_ago.values.sum)]]
    sixteen_days_ago = [[t('defaults.day.16_days_ago'), shaped_time(sixteen_days_ago.values.sum)]]
    seventeen_days_ago = [[t('defaults.day.17_days_ago'), shaped_time(seventeen_days_ago.values.sum)]]
    eighteen_days_ago = [[t('defaults.day.18_days_ago'), shaped_time(eighteen_days_ago.values.sum)]]
    nineteen_days_ago = [[t('defaults.day.19_days_ago'), shaped_time(nineteen_days_ago.values.sum)]]
    twenty_days_ago = [[t('defaults.day.20_days_ago'), shaped_time(twenty_days_ago.values.sum)]]
    @graph_3week = [{ data: twenty_days_ago }, { data: nineteen_days_ago }, { data: eighteen_days_ago },
                    { data: seventeen_days_ago }, { data: sixteen_days_ago }, { data: fifteen_days_ago }, { data: fourteen_days_ago }]
    # 今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_3week = user_channels_time_3week.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_3week = {}
    user_channel_time_each_3week.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_3week[channel.name] = shaped_time
    end

    # 21日前から27日前までのチャンネルの使用時間
    user_channels_time_4week = @user.channel_times.where(created_at: 27.days.ago.beginning_of_day..21.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_4week = caliculate_time(user_channels_time_4week.values.sum)
    # グラフ用
    twentyone_days_ago = @user.channel_times.where(created_at: 21.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentytwo_days_ago = @user.channel_times.where(created_at: 22.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentythree_days_ago = @user.channel_times.where(created_at: 23.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyfour_days_ago = @user.channel_times.where(created_at: 24.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyfive_days_ago = @user.channel_times.where(created_at: 25.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentysix_days_ago = @user.channel_times.where(created_at: 26.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyseven_days_ago = @user.channel_times.where(created_at: 27.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyone_days_ago = [[t('defaults.day.21_days_ago'), shaped_time(twentyone_days_ago.values.sum)]]
    twentytwo_days_ago = [[t('defaults.day.22_days_ago'), shaped_time(twentytwo_days_ago.values.sum)]]
    twentythree_days_ago = [[t('defaults.day.23_days_ago'), shaped_time(twentythree_days_ago.values.sum)]]
    twentyfour_days_ago = [[t('defaults.day.24_days_ago'), shaped_time(twentyfour_days_ago.values.sum)]]
    twentyfive_days_ago = [[t('defaults.day.25_days_ago'), shaped_time(twentyfive_days_ago.values.sum)]]
    twentysix_days_ago = [[t('defaults.day.26_days_ago'), shaped_time(twentysix_days_ago.values.sum)]]
    twentyseven_days_ago = [[t('defaults.day.27_days_ago'), shaped_time(twentyseven_days_ago.values.sum)]]
    @graph_4week = [{ data: twentyseven_days_ago }, { data: twentysix_days_ago }, { data: twentyfive_days_ago },
                    { data: twentyfour_days_ago }, { data: twentythree_days_ago }, { data: twentytwo_days_ago }, { data: twentyone_days_ago }]
    # 今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_4week = user_channels_time_4week.sort_by { |key, value| value }.reverse.first(5).to_h
    @user_channel_time_each_4week = {}
    user_channel_time_each_4week.each do |key, value|
      find_channel = UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_4week[channel.name] = shaped_time
    end

    # 今月のチャンネル使用時間
    user_channels_time_month = @user.channel_times.where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    # 時間表示用
    @user_channels_time_month = caliculate_time(user_channels_time_month.values.sum)

    # 数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = @user.channel_times.where(created_at: 1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = @user.channel_times.where(created_at: 2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = @user.channel_times.where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = @user.channel_times.where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = @user.channel_times.where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = @user.channel_times.where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = @user.channel_times.where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = @user.channel_times.where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = @user.channel_times.where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = @user.channel_times.where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = @user.channel_times.where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [[t('defaults.month.this_month'), shaped_time(user_channels_time_month.values.sum)]]
    a_month_ago_time = [[t('defaults.month.1_month_ago'), shaped_time(a_month_ago.values.sum)]]
    two_month_ago_time = [[t('defaults.month.2_months_ago'), shaped_time(two_month_ago.values.sum)]]
    three_month_ago_time = [[t('defaults.month.3_months_ago'), shaped_time(three_month_ago.values.sum)]]
    four_month_ago_time = [[t('defaults.month.4_months_ago'), shaped_time(four_month_ago.values.sum)]]
    five_month_ago_time = [[t('defaults.month.5_months_ago'), shaped_time(five_month_ago.values.sum)]]
    six_month_ago_time = [[t('defaults.month.6_months_ago'), shaped_time(six_month_ago.values.sum)]]
    seven_month_ago_time = [[t('defaults.month.7_months_ago'), shaped_time(seven_month_ago.values.sum)]]
    eight_month_ago_time = [[t('defaults.month.8_months_ago'), shaped_time(eight_month_ago.values.sum)]]
    nine_month_ago_time = [[t('defaults.month.9_months_ago'), shaped_time(nine_month_ago.values.sum)]]
    ten_month_ago_time = [[t('defaults.month.10_months_ago'), shaped_time(ten_month_ago.values.sum)]]
    eleven_month_ago_time = [[t('defaults.month.11_months_ago'), shaped_time(eleven_month_ago.values.sum)]]
    @months_graph = [{ data: eleven_month_ago_time }, { data: ten_month_ago_time }, { data: nine_month_ago_time },
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
    params.require(:user).permit(:role, :password)
  end
end
