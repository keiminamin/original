require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end
before '/friends' do
  if current_user.nil?
    redirect '/'
  end
end
get '/' do



  if current_user.nil?
    @friends  = Friend.none
  else
    @friends = current_user.friends
  end

  erb :index

end
get '/signin' do
  erb :sign_in

end

get '/signup' do
  erb :sign_up

end

post '/signin' do
  user = User.find_by(mail:params[:mail])
    if user && user.authenticate(params[:password])
    session[:user] = user.id

    end
    redirect '/'
end

post '/signup' do
@user =  User.create(mail:params[:mail],password:params[:password],password_confirmation:params[:password_confirmation],my_birthday:params[:my_birthday])

date = params[:my_birthday].split('-')

  if @user.persisted?
    session[:user] = @user.id

  end
  redirect'/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end


post '/friends' do
  current_user.friends.create(friend_birthday: params[:friend_birthday],friend_name: params[:friend_name],present: params[:present],given: params[:given])
  redirect '/'
end

get '/new' do

  erb :new
end
