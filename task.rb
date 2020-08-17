require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'line/bot'

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

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when current_user.remained_days == -1
        message = { type: 'text', text: '誕生日おめでとうございます' }
        client.push_message(userid, message)


    friend = current_user.friends

    when friend.friend_days == -1
      message = { type:'text', text:"#{friend.friend_birthday.month}月#{friend.friend_birthday.day}日。"text: "#{friend.name}さんの誕生日です。"}
      client.push_message(userid, message)

    end

  end




  }
end