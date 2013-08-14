CobotFb.controller do
  before {redirect '/cobot/auth' unless current_user}

  get '/user' do
    user_info = JSON.parse(oauth_session.get("http://www.cobot.me/api/user").body)
    @spaces_json = user_info['admin_of'].to_json
    if current_user.qb_connected?
      @qb_accounts = []
      page = 1
      while (qb_accounts = Quickeebooks::Online::Service::Account.new(qb_oauth_client(current_user), current_user.qb_realm_id).list([], page, 50).size).length > 0 do
        @qb_accounts << qb_accounts
        page = page + 1
      end
    end
    @enabled_spaces_ids = current_user.spaces.map(&:cobot_id).to_json
    render "user/show"
  end
end