class HomeController < Ramaze::Controller
  engine :Erubis
  set_layout_except :default => [:look]
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

  def look
    me = current_account
    json = { :around => Room.get(me.join_id).look(me.x, me.y),
             :direction => me.direction
    }.to_json
    "(#{json})"
  end

  def turn(direction)
    me = current_account
    me.direction = direction
    me.save
    json = { :result => true
    }.to_json
    "(#{json})"    
  end

end
