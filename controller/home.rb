class HomeController < Ramaze::Controller
  engine :Erubis
  set_layout_except :default => [:look, :turn, :move]
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

  def move
    me = current_account
    around = Room.get(me.join_id).look(me.x, me.y)
    case me.direction
    when 0 then me.x -= 1 if around[2][1] == 0
    when 1 then me.y -= 1 if around[1][2] == 0
    when 2 then me.x += 1 if around[2][3] == 0
    when 3 then me.y += 1 if around[3][2] == 0
    end
    me.save
    json = { :result => true, :x => me.x, :y => me.y}.to_json
    "(#{json})"
  end

  def turn(direction)
    me = current_account
    me.direction = direction
    me.save
    json = { :result => true}.to_json
    "(#{json})"    
  end

end
