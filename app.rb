require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'line/bot'
enable :sessions



helpers do
  def current_user
    User.find_by(id: session[:user])
  end

  def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
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


get '/delete' do
  friend = current_user.friends
  friend.destroy_all
  redirect'/'
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


post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Follow #フォローイベント
      userid = event['source']['userId']

      message = { type: 'text', text: "https://salty-ridge-27900.herokuapp.com/#{userid}/confirm
      こちらから認証してください" }

      client.push_message(userid, message) #push送信

    when Line::Bot::Event::Unfollow #フォロー解除(ブロック)
      userid = event['source']['userId']
      user = User.find_by(userId: userid)
      user.destroy
    end


  #   if current_user.remained_days == -1
  #       message = { type: 'text', text: '誕生日おめでとうございます' }
  #       client.push_message(userid, message)
  #   end

  #   friend = current_user.friends

  # if current_user.friend_days == -1
  #     message = { type:'text', text:"#{friend.friend_birthday.month}月#{friend.friend_birthday.day}日。"text: "#{friend.name}さんの誕生日です。"}
  #     client.push_message(userid, message)
  #   end
  # end


  }
end

get '/:userid/confirm' do
  user = params[:userid]
  erb :confirm
end

post '/:userid/confirm' do


  def user
    params[:userid]
    User.find_by(mail:params[:mail])
  end

    if user && user.authenticate(params[:password])




      userid = user.userId
      user.save

    redirect '/'
    else
      redirect"/#{userid}/confirm "
    end



end