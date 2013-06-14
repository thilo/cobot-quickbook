CobotFb.controller  do
  get '/cobot/auth' do
    redirect oauth_client.auth_code.authorize_url(
      :redirect_uri => base_url+'/cobot/callback',
      scope: 'read read_user'
    )
  end
  
  get '/cobot/callback' do
    oauth_session = oauth_client.auth_code.get_token(params[:code], :redirect_uri => base_url)
    session[:token] = oauth_session.token
    redirect 'session/new'
  end
  
  get '/quickbooks/auth' do
    token = qb_oauth_consumer.get_request_token(:oauth_callback => base_url + '/quickbooks/callback')
    session[:qb_request_token] = token
    redirect "https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}"
  end
  
  get '/quickbooks/callback' do
    access_token = session[:qb_request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    current_user.update_attributes(qb_token: access_token.token, qb_secret: access_token.secret, qb_realm_id: params['realmId'])
    redirect '/user'
  end
end