require 'bundler/setup'
Bundler.require


if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end
  class User < ActiveRecord::Base

has_secure_password
  validates :mail,
    presence: true

    validates :password,
    length: {in: 5..10}
    has_many :friends

    validates :my_birthday,
    presence: true

      def remained_days

        return( my_birthday.yday - Date.today.yday).to_i
      end


  end

  class Friend < ActiveRecord::Base
    validates :friend_birthday,
    presence: true
    validates :friend_name,
    presence: true
    validates :present,
    presence: true

    belongs_to :user


    def friend_days
        if friend_birthday.yday > Date.today.yday


      return (friend_birthday.yday - Date.today.yday).to_i

        else
      return (friend_birthday.yday - Date.today.yday+365).to_i
        end

    end


    def friend_celebrate

      return (friend_birthday.yday- Date.today.yday).to_i





    end
  end
