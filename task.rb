require './models'
require 'line/bot'
require 'dotenv'

def client
  @client ||= Line::Bot::Client.new { |config|
    # config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    # config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    config.channel_secret = "353fd7fd5c7d7a00d583fa6b29e1ed4c

"
    config.channel_token = "NXf6DRp0cLoQEr0xhCkeaARJ4FKZof3sEdfNnQSNL/XDb12QGFrJ6H/rPOZZRPC8FX69N3LGXHLLaL8TXv59eYpLxocLe3SCsoYBAg6dtqAA2680UWkNtxi4csn5a79J04HCI9livgclVBnk2vmSPgdB04t89/1O/w1cDnyilFU="
  }
  end




  # userid = "U7852d2b3ee71aa7c8d18a5c39ef885b2"
  users = User.all
    users.each do |user|




    if user.remained_days == -1
userid = user.userId
  message = { type: 'text', text: "お誕生日おめでとうございます！友達更新が可能です。
    https://salty-ridge-27900.herokuapp.com/" }

      client.push_message(userid, message)
    end

    friends = user.friends

    friends.each do |friend|

      if friend.friend_celebrate == -1

      userid = user.userId
      message = { type: 'text', text: "#{friend.friend_name}さんの誕生日です。お祝いしましょう！" }
        client.push_message(userid, message)
        puts "aa"


      end
    end




end
