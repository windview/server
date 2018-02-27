class CreateForecastTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :forecast_types do |t|
      t.string :name, null: false
      t.string :label, null: false

      t.timestamps
    end

    add_index :forecast_types, :name, unique: true
    add_index :forecast_types, :label, unique: true
  end
end
