class Api::V1::ChannelTimesController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    puts "アクションが届いています。"
    puts params
    time = Time.new
  end

  private

  def bot_params
    params.permit(:user_id, :user_name, :channel_id, :channel_name)
  end
end
