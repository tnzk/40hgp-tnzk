# Configure the application 
options = {
  'development' => {
    :database => "sqlite3://#{ENV['APP_ROOT']}/db/nobela_jp.db",
    :port     => 3030
  },
  'production' => { 
    :database => { :adapter  => 'mysql',
                   :database => 'nobela',
                   :username => 'nobela',
                   :password => 'Nq70849tM',
                   :host     => 'db.opentaka.org'},
    :port     => 80
  }
}
nobela_conf = options[ENV['RACK_ENV']]


# Load Standard Libraries
require 'digest/sha2'
require 'jcode'

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
Ramaze.options.roots = [ENV['APP_ROOT']]
Ramaze.options.views = ['views']
Ramaze.options.cache.session = Ramaze::Cache::MemCache

# Load models
Ramaze.acquire "#{ENV['APP_ROOT']}/models/*"

# Load controllers
Ramaze.acquire "#{ENV['APP_ROOT']}/lib/nobela/jp/*"

