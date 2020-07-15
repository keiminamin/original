class AddToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :my_birthday, :date
  end
end
