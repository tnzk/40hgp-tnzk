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
    room = Room.get(me.join_id)
    json = { :around => room.look(me.x, me.y),
             :partners => room.insiders.delete_if{|account| account == current_account}.map{ |account|
               { :name => account.name,
                 :x => account.x - current_account.x + 2,
                 :y => account.y - current_account.y + 2,
                 :d => account.direction}},
             :direction => me.direction,
             :owner => room.owner.name,
             :attendant => room.insiders.map{|account| account.name}.join(' / '),
             :floor => room.floor,
             :npcs => room.visible_npcs(current_account.x, current_account.y).map {|h|
               { :id => h['id'],
                 :type => h['type'],
                 :x => h['x'] - current_account.x + 2,
                 :y => h['y'] - current_account.y + 2,
                 :d => h['d'],
                 :since => h['since']}}
    }.to_json
    "(#{json})"
  end

  def move
    result = false
    me = current_account
    room = Room.get(me.join_id)
    if room.token == me.id
      me.move!(room)
      room.next!
      result = true
    end
    json = { :result => result, :x => me.x, :y => me.y}.to_json
    "(#{json})"
  end

  def turn(direction)
    me = current_account
    me.direction = direction
    me.save
    json = { :result => true}.to_json
    "(#{json})"    
  end

  def track(user_id)
    me = current_account
    me.track_to = user_id
    p me.save
    json = { :result => true}.to_json
    "(#{json})"    
  end

end
