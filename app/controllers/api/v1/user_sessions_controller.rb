class Api::V1::UserSessionsController < Api::V1::BaseController
  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました'
  end
end
