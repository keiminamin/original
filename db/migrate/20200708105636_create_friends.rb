class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.references :user
      t.date :friend_birthday
      t.string :friend_name
      t.string :present
      t.boolean :given
      t.timestamps null: false
    end
  end
end
