class Room
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String,  :default => 'Unnamed room'
  property :floor,   Integer, :default => 0
  property :field,   Text
  property :players, Text,    :default => '[]'

  timestamps :at
  timestamps :on

  belongs_to :account # Creator

  def join(user_id)
    self.players = JSON.parse(self.players).push(user_id).to_json
    self.save
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

  def down!
    self.floor += 1
    # Generate 50x50 blank map and save it as json
    self.field = ([[0] * 50] * 50).to_json
    self.save
  end

end

