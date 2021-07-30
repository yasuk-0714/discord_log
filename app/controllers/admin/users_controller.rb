class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(uuid: params[:uuid])
    @guilds = @user.guilds
    @channels = @user.channels.order(position: :asc).map {|user_channel| user_channel }

    #ユーザーが所持しているチャンネルごとに時間を算出
    time_all = @user.channel_times.group(:user_channel_id).sum(:total_time)

    #ユーザーが参加しているチャンネルの総合時間 :表示用
    @total_time = caliculate_time(time_all.values.sum)
    #ユーザーが参加しているチャンネルの総合時間 :グラフ用
    @time_all = {}
    @time_all['合計時間'] = shaped_time(time_all.values.sum)

    #全てのユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_all = time_all.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_all = {}
    user_channel_time_each_all.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_all[channel.name] = shaped_time
    end

    #これまでのユーザーが参加している各チャンネルの使用時間
    @user_channels_time_all = {}
    time_all.sort_by {|k,v| v}.reverse.to_h.each do |key, value|
      user_channel =  UserChannel.find(key)
      channel = Channel.find(user_channel.channel_id)
      shaped_time = shaped_time(value)
      @user_channels_time_all[channel.name] = shaped_time
    end

    #今日から６日前までのチャンネルの使用時間
    user_channels_time_week = @user.channel_times.where(created_at: 6.days.ago.beginning_of_day..Time.now.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_week = caliculate_time(user_channels_time_week.values.sum)
    #グラフ用
    on_day = @user.channel_times.where(created_at: Time.now.all_day).group(:user_channel_id).sum(:total_time)
    day_ago = @user.channel_times.where(created_at: 1.day.ago.all_day).group(:user_channel_id).sum(:total_time)
    two_days_ago =  @user.channel_times.where(created_at: 2.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    three_days_ago = @user.channel_times.where(created_at: 3.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    four_days_ago = @user.channel_times.where(created_at: 4.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    five_days_ago = @user.channel_times.where(created_at: 5.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    six_days_ago = @user.channel_times.where(created_at: 6.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    on_day = [['今日', shaped_time(on_day.values.sum)]]
    day_ago = [['１日前', shaped_time(day_ago.values.sum)]]
    two_days_ago = [['２日前', shaped_time(two_days_ago.values.sum)]]
    three_days_ago = [['３日前', shaped_time(three_days_ago.values.sum)]]
    four_days_ago = [['４日前', shaped_time(four_days_ago.values.sum)]]
    five_days_ago = [['５日前', shaped_time(five_days_ago.values.sum)]]
    six_days_ago = [['６日前', shaped_time(six_days_ago.values.sum)]]
    @graph_week = [{name: '6日前', data: six_days_ago}, {name: '５日前', data: five_days_ago}, {name: '４日前', data: four_days_ago},
              {name:'３日前', data: three_days_ago}, {name: '２日前', data: two_days_ago}, {name: '１日前', data: day_ago}, {name: '今日', data: on_day}]
    #今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_week = user_channels_time_week.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_week = {}
    user_channel_time_each_week.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_week[channel.name] = shaped_time
    end

    #7日前から13日前までのチャンネルの使用時間
    user_channels_time_2week = @user.channel_times.where(created_at: 7.days.ago.beginning_of_day..13.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_2week = caliculate_time(user_channels_time_week.values.sum)
    #グラフ用
    seven_days_ago = @user.channel_times.where(created_at: 7.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eight_days_ago = @user.channel_times.where(created_at: 8.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    nine_days_ago =  @user.channel_times.where(created_at: 9.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    ten_days_ago = @user.channel_times.where(created_at: 10.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eleven_days_ago = @user.channel_times.where(created_at: 11.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twelve_days_ago = @user.channel_times.where(created_at: 12.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    thirteen_days_ago = @user.channel_times.where(created_at: 13.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    seven_days_ago = [['７日前', shaped_time(seven_days_ago.values.sum)]]
    eight_days_ago = [['8日前', shaped_time(eight_days_ago.values.sum)]]
    nine_days_ago = [['9日前', shaped_time(nine_days_ago.values.sum)]]
    ten_days_ago = [['10日前', shaped_time(ten_days_ago.values.sum)]]
    eleven_days_ago = [['11日前', shaped_time(eleven_days_ago.values.sum)]]
    twelve_days_ago = [['12日前', shaped_time(twelve_days_ago.values.sum)]]
    thirteen_days_ago = [['13日前', shaped_time(thirteen_days_ago.values.sum)]]
    @graph_2week = [{name: '13日前', data: thirteen_days_ago}, {name: '12日前', data: twelve_days_ago}, {name: '11日前', data: eleven_days_ago},
              {name:'10日前', data: ten_days_ago}, {name: '9日前', data: nine_days_ago}, {name: '8日前', data: eight_days_ago}, {name: '7日前', data: seven_days_ago}]
    #今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_2week = user_channels_time_2week.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_2week = {}
    user_channel_time_each_2week.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_2week[channel.name] = shaped_time
    end

    #14日前から20日前までのチャンネルの使用時間
    user_channels_time_3week = @user.channel_times.where(created_at: 14.days.ago.beginning_of_day..20.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_3week = caliculate_time(user_channels_time_week.values.sum)
    #グラフ用
    fourteen_days_ago = @user.channel_times.where(created_at: 14.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    fifteen_days_ago = @user.channel_times.where(created_at: 15.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    sixteen_days_ago =  @user.channel_times.where(created_at: 16.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    seventeen_days_ago = @user.channel_times.where(created_at: 17.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    eighteen_days_ago = @user.channel_times.where(created_at: 18.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    nineteen_days_ago = @user.channel_times.where(created_at: 19.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twenty_days_ago = @user.channel_times.where(created_at: 20.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    fourteen_days_ago = [['14日前', shaped_time(fourteen_days_ago.values.sum)]]
    fifteen_days_ago = [['15日前', shaped_time(fifteen_days_ago.values.sum)]]
    sixteen_days_ago = [['16日前', shaped_time(sixteen_days_ago.values.sum)]]
    seventeen_days_ago = [['17日前', shaped_time(seventeen_days_ago.values.sum)]]
    eighteen_days_ago = [['18日前', shaped_time(eighteen_days_ago.values.sum)]]
    nineteen_days_ago = [['19日前', shaped_time(nineteen_days_ago.values.sum)]]
    twenty_days_ago = [['20日前', shaped_time(twenty_days_ago.values.sum)]]
    @graph_3week = [{name: '20日前', data: twenty_days_ago}, {name: '19日前', data: nineteen_days_ago}, {name: '18日前', data: eighteen_days_ago},
              {name:'17日前', data: seventeen_days_ago}, {name: '16日前', data: sixteen_days_ago}, {name: '15日前', data: fifteen_days_ago}, {name: '14日前', data: fourteen_days_ago}]
    #今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_3week = user_channels_time_3week.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_3week = {}
    user_channel_time_each_3week.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_3week[channel.name] = shaped_time
    end

    #21日前から27日前までのチャンネルの使用時間
    user_channels_time_4week = @user.channel_times.where(created_at: 21.days.ago.beginning_of_day..27.days.ago.end_of_day).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_4week = caliculate_time(user_channels_time_week.values.sum)
    #グラフ用
    twentyone_days_ago = @user.channel_times.where(created_at: 21.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentytwo_days_ago = @user.channel_times.where(created_at: 22.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentythree_days_ago =  @user.channel_times.where(created_at: 23.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyfour_days_ago = @user.channel_times.where(created_at: 24.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyfive_days_ago = @user.channel_times.where(created_at: 25.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentysix_days_ago = @user.channel_times.where(created_at: 26.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyseven_days_ago = @user.channel_times.where(created_at: 27.days.ago.all_day).group(:user_channel_id).sum(:total_time)
    twentyone_days_ago = [['21日前', shaped_time(twentyone_days_ago.values.sum)]]
    twentytwo_days_ago = [['22日前', shaped_time(twentytwo_days_ago.values.sum)]]
    twentythree_days_ago = [['23日前', shaped_time(twentythree_days_ago.values.sum)]]
    twentyfour_days_ago = [['24日前', shaped_time(twentyfour_days_ago.values.sum)]]
    twentyfive_days_ago = [['25日前', shaped_time(twentyfive_days_ago.values.sum)]]
    twentysix_days_ago = [['26日前', shaped_time(twentysix_days_ago.values.sum)]]
    twentyseven_days_ago = [['27日前', shaped_time(twentyseven_days_ago.values.sum)]]
    @graph_4week = [{name: '27日前', data: twentyseven_days_ago}, {name: '26日前', data: twentysix_days_ago}, {name: '25日前', data: twentyfive_days_ago},
              {name:'24日前', data: twentyfour_days_ago}, {name: '23日前', data: twentythree_days_ago}, {name: '22日前', data: twentytwo_days_ago}, {name: '21日前', data: twentyone_days_ago}]
    #今週のユーザーチャンネルの使用時間トップ5を算出
    user_channel_time_each_4week = user_channels_time_4week.sort_by {|k,v| v}.reverse.first(5).to_h
    @user_channel_time_each_4week = {}
    user_channel_time_each_4week.each do |key, value|
      find_channel =  UserChannel.find(key)
      channel = Channel.find(find_channel.channel_id)
      shaped_time = caliculate_time(value)
      @user_channel_time_each_4week[channel.name] = shaped_time
    end

    #今月のチャンネル使用時間
    user_channels_time_month = @user.channel_times.where(created_at: Time.now.all_month).group(:user_channel_id).sum(:total_time)
    #時間表示用
    @user_channels_time_month = caliculate_time(user_channels_time_month.values.sum)

    #数ヶ月前までのチャンネル使用時間: グラフ用
    a_month_ago = @user.channel_times.where(created_at:  1.month.ago.all_month).group(:user_channel_id).sum(:total_time)
    two_month_ago = @user.channel_times.where(created_at:  2.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    three_month_ago = @user.channel_times.where(created_at: 3.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    four_month_ago = @user.channel_times.where(created_at: 4.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    five_month_ago = @user.channel_times.where(created_at: 5.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    six_month_ago = @user.channel_times.where(created_at: 6.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    seven_month_ago = @user.channel_times.where(created_at: 7.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eight_month_ago = @user.channel_times.where(created_at: 8.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    nine_month_ago = @user.channel_times.where(created_at: 9.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    ten_month_ago = @user.channel_times.where(created_at: 10.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    eleven_month_ago = @user.channel_times.where(created_at: 11.months.ago.all_month).group(:user_channel_id).sum(:total_time)
    this_month_time = [['今月', shaped_time(user_channels_time_month.values.sum)]]
    a_month_ago_time = [['1ヶ月前', shaped_time(a_month_ago.values.sum)]]
    two_month_ago_time = [['2ヶ月前', shaped_time(two_month_ago.values.sum)]]
    three_month_ago_time = [['3ヶ月前', shaped_time(three_month_ago.values.sum)]]
    four_month_ago_time = [['4ヶ月前', shaped_time(four_month_ago.values.sum)]]
    five_month_ago_time = [['5ヶ月前', shaped_time(five_month_ago.values.sum)]]
    six_month_ago_time = [['6ヶ月前', shaped_time(six_month_ago.values.sum)]]
    seven_month_ago_time = [['7ヶ月前', shaped_time(seven_month_ago.values.sum)]]
    eight_month_ago_time = [['8ヶ月前', shaped_time(eight_month_ago.values.sum)]]
    nine_month_ago_time = [['9ヶ月前', shaped_time(nine_month_ago.values.sum)]]
    ten_month_ago_time = [['10ヶ月前', shaped_time(ten_month_ago.values.sum)]]
    eleven_month_ago_time = [['11ヶ月前', shaped_time(eleven_month_ago.values.sum)]]
    @months_graph = [{name: '11ヶ月前', data: eleven_month_ago_time}, {name: '10ヶ月前', data: ten_month_ago_time}, {name: '9ヶ月前', data: nine_month_ago_time},
                      {name: '8ヶ月前', data: eight_month_ago_time}, {name: '7ヶ月前', data: seven_month_ago_time}, {name: '6ヶ月前', data: six_month_ago_time},
                      {name: '5ヶ月前', data: five_month_ago_time}, {name: '4ヶ月前', data: four_month_ago_time}, {name: '3ヶ月前', data: three_month_ago_time},
                      {name: '2ヶ月前', data: two_month_ago_time}, {name: '1ヶ月前', data: a_month_ago_time}, {name: '今月', data: this_month_time}]
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_root_path, success: 'ユーザー更新に成功しました'
    else
      flash.now['danger'] = 'ユーザー更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_root_path, success: 'ユーザーを削除しました'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :password)
  end
end