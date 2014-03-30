class CreateDiabetics < ActiveRecord::Migration
  def change
    create_table :diabetics do |t|
      t.string :name, :email, :null => false
      t.date :birthday, :null => false
      t.boolean :confirmed, :default => false
      t.belongs_to :doctor
      t.belongs_to :account
    end
  end
end
