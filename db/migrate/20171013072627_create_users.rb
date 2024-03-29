class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :provider
      t.string :gender
      t.string :email
      t.string :country
      t.date :birthdate
      t.string :password_digest

      t.timestamps
    end
  end
end
