CobotFb.controller  do
  post '/spaces' do
    current_user.spaces.create!(params[:space])
  end

  delete '/spaces/:id' do
    current_user.spaces.find(params[:id]).disable
  end

  put 'spaces/:id' do
    current_user.spaces.find(params[:id]).enable
  end
end