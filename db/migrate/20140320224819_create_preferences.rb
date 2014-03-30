class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.boolean :reminders
      t.integer :frequency
      t.belongs_to :diabetic
    end
  end
end
