require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/message_board'
require_relative 'lib/user'
require_relative 'lib/database_connection_setup'
class Blog_App < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    erb :index
  end

  post '/messages' do
    if User.check_login(username: params[:username], password: params[:password])
      session[:username] = params[:username]
      redirect '/message_board'
    else
      flash[:notice] = 'Incorrect username or password!'
      redirect '/'
    end
  end

  # Post for creating new account
  post '/messages/new_user' do
    if User.create_user(username: params[:username], password: params[:password])
      session[:username] = params[:username]
      redirect '/message_board'
    else
      flash[:notice] = 'Username taken!'
      redirect '/'
    end

  end

  
  get '/message_board' do 
    @username = session[:username]
    @messages = Message_board.all
    erb :message_board
  end

  get '/add_message' do 
    erb :add_message
  end 

  post '/add_message' do
    message = params[:message] + " -- #{session[:username]}"
    Message_board.add(message)
    redirect '/message_board'
  end  

  delete '/messages/:id' do
    Message_board.delete(id: params[:id])
    redirect '/message_board'
  end 


end