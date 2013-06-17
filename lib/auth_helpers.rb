module AuthHelpers
  def qb_oauth_consumer
    @qb_oauth_consumer ||= OAuth::Consumer.new(CobotFb::Config[:qb_app_id], CobotFb::Config[:qb_app_key], {
      site: "https://oauth.intuit.com",
      request_token_path: "/oauth/v1/get_request_token",
      authorize_url: "https://appcenter.intuit.com/Connect/Begin",
      access_token_path: "/oauth/v1/get_access_token"
    })
  end

  def qb_oauth_client(user)
    oauth_client = OAuth::AccessToken.new(qb_oauth_consumer, user.access_token, user.access_secret)
  end

  def oauth_client
    OAuth2::Client.new(CobotFb::Config[:cobot_app_id],
      CobotFb::Config[:cobot_app_key],
      site: 'https://www.cobot.me',
      token_url: '/oauth/access_token',
      authorize_url: '/oauth/authorize',
      raise_errors: false)
  end
  
  def get_oauth_session(token)
    oauth_session = OAuth2::AccessToken.new(oauth_client, token, scope: 'read read_user')
    oauth_session.options[:header_format] = "OAuth %s"
    oauth_session
  end
end