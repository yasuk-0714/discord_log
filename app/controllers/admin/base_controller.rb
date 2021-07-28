class Admin::BaseController < ApplicationController
  layout 'admin/layouts/application'
  before_action :check_admin
  before_action :require_login
  private

  def not_authenticated
    redirect_to admin_login_path, warning: "ログインしてください"
  end

  def check_admin
    redirect_to root_path, warning: "管理者以外ログインできません" unless current_user.admin?
  end
end
