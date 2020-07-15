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
  date = params[:friend_birthday].split('-')
  if Date.valid_date?(date[0].to_i,date[1].to_i,date[2].to_i)
  current_user.friends.create(friend_name: params[:friend_name],present: params[:present],my_birthday: Date.parse(params[:my_birthday]))

  else
  redirect '/friends/:id/new'
  end
end

get '/:id/new/given' do
  friend = Friend.find(params[:id])
  friend.given = !frind.given
  friend.save
  redirect '/'


end

get '/:id/new' do
  if Friend.where(params[:id])
  @friend = Friend.where(params[:id])
  end
  erb :new
end
