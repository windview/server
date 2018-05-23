class CreateActuals < ActiveRecord::Migration[5.1]
  def change
    create_table :actuals do |t|
      t.references :farm, foreign_key: true, null: false
      t.datetime :timestamp_utc, null: false
      t.float :actual_mw, null: false

      t.timestamps
    end
  end
end
