CobotFb.controller do
  before {redirect '/cobot/auth' unless current_user}

  get '/user' do
    user_info = JSON.parse(oauth_session.get("http://www.cobot.me/api/user").body)
    @spaces_json = user_info['admin_of'].to_json
    @enabled_spaces_ids = current_user.spaces.map(&:cobot_id).to_json
    render "user/show"
  end
end