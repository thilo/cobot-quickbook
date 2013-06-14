def oauth_stub
  oauth_consumer = OAuth::Consumer.new('key', 'secret',
      :site                 => "https://oauth.intuit.com",
      :request_token_path   => "/oauth/v1/get_request_token",
      :authorize_path       => "/oauth/v1/get_access_token",
      :access_token_path    => "/oauth/v1/get_access_token"
  )
  OAuth::AccessToken.new(oauth_consumer, "blah", "blah")
end


def oauth2_stub
  oauth_client = OAuth2::Client.new('key', 'secret',
    site:           'https://cobot.me',
    token_url:      '/oauth/access_token',
    authorize_url:  '/oauth/authorize',
    raise_errors:   false
  )
  OAuth2::AccessToken.new(oauth_client, "bla", scope: 'read signin')
end