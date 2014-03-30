class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username, unique: true
      t.string :password_digest
      t.string :email, unique: true
    end
  end
end

