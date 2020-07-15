ActiveRecord::Base.establish_connection("sqlite3:db/development.db")

  class User < ActiveRecord::Base

has_secure_password
  validates :mail,
    presence: true

    validates :password,
    length: {in: 5..10}
    has_many :friends

      def remained_days
        return( my_birthday - Date.today).to_i
      end
  end

  class Friend < ActiveRecord::Base

    belongs_to :user


  end
