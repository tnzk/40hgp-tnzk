class Room
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String,  :default => 'Unnamed room'
  property :floor,     Integer, :default => 0
  property :field,     Text
  property :players,   Text,    :default => '[]'
  property :npcs,      Text,    :default => '[]'
  property :statement, Text,    :default => '[]'
  property :token,     Integer
 
  timestamps :at
  timestamps :on

  belongs_to :account # Creator

  def join(user_id)
    self.players = JSON.parse(self.players).push(user_id).to_json
    self.token = user_id
    self.save
    account = Account.get(user_id)
    account.x = rand(50)
    account.y = rand(50)
    account.hp_max = account.hp = 0
    account.mp_max = account.mp = 0
    account.join_id = self.id
    account.save
  end

  def leave(user_id)
    arr = JSON.parse(self.players)
    arr.delete(user_id)
    self.players = arr.to_json
    self.save
  end

  def joined?(user_id)
    JSON.parse(self.players).include?(user_id)
  end
  
  def insiders
    JSON.parse(self.players).map{|id| Account.get(id)}
  end

  def look(x,y)
    field = JSON.parse(self.field)
    arrs = []
    5.times{ arrs << ([1]*5)}
    lx = x - 2
    ly = y - 2
    
    for i in 0...5
      for j in 0...5
        if (lx + j) >= 0 && (ly + i) >= 0 &&  (lx + j) <= 49 && (ly + i) <= 49
          arrs[i][j] = field[lx + j][ly + i]
        end
      end
    end
    arrs
  end

  def next!
    now = self.token
    insiders = self.insiders
    while !insiders.empty?
      if insiders.shift.id == now
        nxt_candicate = insiders.shift
        if nxt_candicate
          if nxt_candicate.track_to.to_i != 0
            target = Account.get(nxt_candicate.track_to)
            dx = target.x - nxt_candicate.x
            dy = target.y - nxt_candicate.y
            if dx.abs == dy.abs
              dx += rand(3) - 1
              dy += rand(3) - 1
            end
            if dx.abs > dy.abs
              nxt_candicate.direction = 0 if dx < 0
              nxt_candicate.direction = 2 if dx > 0
            end
            if dx.abs < dy.abs
              nxt_candicate.direction = 1 if dy < 0
              nxt_candicate.direction = 3 if dy > 0
            end
            nxt_candicate.move!(self)
            next
          end
          self.token = nxt_candicate.id
        else
          # NPC AI
          self.token = self.insiders[0].id
        end
        self.save
        return self.token
      end
    end
  end

  def owner
    Account.get(self.token)
  end

  def visible_npcs(x,y)
    npcs = JSON.parse(self.npcs)
    npcs.delete_if{|npc| (npc['x'] - x).abs > 4 || (npc['y'] - y).abs > 4}
  end

  def down!
    self.floor += 1
    # Generate 50x50 blank map and save it as json
    arrs = []
    50.times do
      arrs << ([0]*50)
    end
    1000.times do
      arrs[rand(50)][rand(50)] = rand(4)
    end

    npcs = []
    100.times do |i|
      duplicated = true
      while duplicated
        x = rand(50)
        y = rand(50)
        duplicated = false
        npcs.each {|npc| duplicated = true if npc[:x] == x && npc[:y] == y}
      end
      npcs << {:id => i, :type => rand(8), :x => x, :y => y, :d => rand(4), :since => []}
      arrs[x][y] = 0
    end

    self.field = arrs.to_json
    self.npcs = npcs.to_json

    self.save
  end

end

