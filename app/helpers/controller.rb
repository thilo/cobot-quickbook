CobotFb.helpers do
  include AuthHelpers
  def log(value)
    logger.debug(value)
  end

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def oauth_session
    token = session[:token] || current_user.try(:token)
    token ? get_oauth_session(token) : nil
  end

  def get_space_id(space_url)
    space_url.match(/api\/spaces\/([\w-]+)/)[1]
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    session[:user_id] = user.try(:id)
    @current_user = user
  end

end