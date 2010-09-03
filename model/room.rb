class Room
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :default => 'Unnamed room'

  timestamps :at
  timestamps :on

  belongs_to :account

end

