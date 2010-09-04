class Room
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String,  :default => 'Unnamed room'
  property :floor,     Integer, :default => 0
  property :field,     Text
  property :players,   Text,    :default => '[]'
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
    account.x = 5
    account.y = 5
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

  def down!
    self.floor += 1
    # Generate 50x50 blank map and save it as json
    arrs = []
    50.times do
      arrs << ([0]*50)
    end
    1000.times do
      arrs[rand(50)][rand(50)] = 1
    end
    self.field = arrs.to_json
    self.save
  end

end

