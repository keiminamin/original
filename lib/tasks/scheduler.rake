desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  NewsFeed.update
  puts "done."
end

task :send_reminders => :environment do
  User.send_reminders
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
      userid = event['source']['userId']  #userId取得
      current_user = User.new
      current_user.UserId = userid
      current_user.save
      message = { type: 'text', text: '登録しました' }
      client.push_message(current_user.userId, message) #push送信
    when Line::Bot::Event::Unfollow #フォロー解除(ブロック)
      userid = event['source']['userId']
      user = User.find_by(userId: userid)
      user.destroy
    end


    when current_user.remained_days == -1
        message = { type: 'text', text: '誕生日おめでとうございます'}
        client.push_message(message)
    end

    friend = current_user.friends

  when friend.friend_days == -1
      message = { type:'text', text:"#{friend.friend_birthday.month}月#{friend.friend_birthday.day}日。"text: "#{friend.name}さんの誕生日です。"}

  end


  }
end