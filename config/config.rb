# Configure the application 
options = {
  'development' => {
    :database => "sqlite3://#{Ramaze.options.roots.first}/db/40hgp.db",
    :port     => 3030
  }
}

RACK_ENV = ENV['RACK_ENV'] ||= 'development'
nobela_conf = options[RACK_ENV]

# Load Standard Libraries
require 'digest/sha2'

# Load gems
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-types'
require 'dm-pager'
require 'json'
require 'rdiscount'

# Setup DataMapper
DataMapper.setup(:default, nobela_conf[:database])

# Setup Ramaze options
Ramaze.options.mode = :live
Ramaze.options.adapter.port = nobela_conf[:port]
#Ramaze.options.roots = [ENV['APP_ROOT']]
Ramaze.options.views = ['view']
#Ramaze.options.cache.session = Ramaze::Cache::MemCache

# Load models
$: << '.'
require 'model/room'

# Load controllers
# Ramaze.acquire "#{ENV['APP_ROOT']}/lib/nobela/jp/*"

