# Default url mappings are:
#  a controller called Main is mapped on the root of the site: /
#  a controller called Something is mapped on: /something
# If you want to override this, add a line like this inside the class
#  map '/otherurl'
# this will force the controller to be mounted on: /otherurl

class MainController < Ramaze::Controller
  map '/'
  engine :Erubis
  set_layout_except :default => [:signup, :login, :logout]
  helper :account_helper

  
  def index
    @title = 'Home'
    @rooms = Room.all(:order => [:id.desc])
  end

  def signup
    @title = 'Sign up'
    if request.post?
      name = request['name']
      mail = request['mail']
      password = passwd( request['password'])
      @account = Account.create( :name => name, :password => password, :email => mail)
      result = @account.save
      messages = result ? [] : @account.errors.full_messages
    end
    "(#{{'result' => result, 'messages' => messages}.to_json})"
  end

  def login
    @title = 'Login'
    if request.post?
      name = request['name']
      password = passwd( request['password'])
      @account = Account.first( :name => name, :password => password)
      if @account
        session[:account] = @account.id 
        result = true
      else
        result = false
      end
    end
    "(#{{'result' => result}.to_json})"
  end

  def logout
    session[:account] = nil
    redirect_referer
  end

end
