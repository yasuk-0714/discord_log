module UserSessionsHelper
  def login_as(user)
    visit "/login_as/#{user.id}"
  end
end