class Room
  include DataMapper::Resource

  property :id,               Serial
  property :name,             String
  property :email,            String

  timestamps :at
  timestamps :on

end
