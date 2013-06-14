CobotFb.controller  do
  post '/spaces' do
    current_user.spaces.create!(params[:space])
  end
end