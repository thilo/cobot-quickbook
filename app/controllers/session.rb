CobotFb.controller do
  get '/session/new' do
    if oauth_session
      user_info = JSON.parse(oauth_session.get("http://www.cobot.me/api/user").body)
      self.current_user = User.find_or_create_for_cobot_id(user_info['id'], {token: session[:token]})
      redirect '/user'
    else
      redirect '/cobot/auth'
    end
  end
end