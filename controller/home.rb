class HomeController < Ramaze::Controller
  engine :Erubis
  layout :default
  helper :account_helper

  def index
  end

  def join(id)
    room = Room.get(id)
    room.join(current_account.id) unless room.joined?(current_account.id)
    redirect "/room/show/#{room.id}"
  end

  def leave(id)
    room = Room.get(id)
    room.leave(current_account.id) if room.joined?(current_account.id)
    redirect '/'
  end
end
