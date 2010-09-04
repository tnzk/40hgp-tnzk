class Room
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String,  :default => 'Unnamed room'
  property :floor,     Integer, :default => 0
  property :field,     Text
  property :players,   Text,    :default => '[]'
  property :statement, Text,    :default => '[]'
 

  timestamps :at
  timestamps :on

  belongs_to :account # Creator

  def join(user_id)
    self.players = JSON.parse(self.players).push(user_id).to_json
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
        arrs[i][j] = field[lx + j][ly + i] if (lx + j) >= 0 && (ly + i) >= 0
      end
    end
    arrs
  end


  def down!
    self.floor += 1
    # Generate 50x50 blank map and save it as json
    arrs = []
    seed = [0,0,0,0,2]
    50.times do
      seed.reverse!
      arrs << (seed * 10)
    end
    self.field = arrs.to_json
    self.save
  end

end

