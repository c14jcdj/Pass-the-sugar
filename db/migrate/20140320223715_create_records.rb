class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :diabetic
      t.string :weight
      t.string :glucose
      t.datetime :taken_at
      t.timestamps
    end
    #add herer index mon
  end
end
