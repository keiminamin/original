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


    if
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end


  }

  "OK"
end
