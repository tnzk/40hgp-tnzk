class Account
  include DataMapper::Resource
  
  property :id,         Serial,   :required => true
  property :name,       String,   :required => true
  property :password,   String,   :required => true,  :length => 128
  property :email,      String,   :required => true

  property :hp,         Integer,  :required => false
  property :hp_max,     Integer,  :required => false
  property :mp,         Integer,  :required => false
  property :mp_max,     Integer,  :required => false
  property :x,          Integer,  :required => false
  property :y,          Integer,  :required => false

  property :join_id,    Integer,  :required => false # For relation, workaround

  timestamps :at
  timestamps :on

  validates_uniqueness_of :name,  :message => 'The specified ID has already been used.'
  validates_uniqueness_of :email, :message => 'The specified mail address has already been used.'
  
  validates_length_of :name, :min => 3, :max => 64, :message  => ''
  validates_format_of :name,  :with => /^[0-9a-z_]+$/, :message => 'Invalid character'
  validates_format_of :email, :as => :email_address,   :message => 'Invalid mail address'

  has n, :rooms

  def gravatar(size = 48)
    url = self.gravatar_url( size)
    "<img src=\"#{url}\" alt=\"#{self.pen_name_s}\" />"
  end
  def gravatar_url(size = 48)
    "http://www.gravatar.com/avatar/#{ Digest::MD5.hexdigest( self.email.chomp.downcase).to_s}?s=#{size}&r=g&d=identicon"
  end
  

end
