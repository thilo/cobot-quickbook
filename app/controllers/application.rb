CobotFb.controller do
  get '/', :cache => true do
    render "application/index"
  end
end