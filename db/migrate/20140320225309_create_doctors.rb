class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :fax
      t.text :comments
      t.string :email
    end
  end
end
