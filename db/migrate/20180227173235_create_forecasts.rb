class CreateForecasts < ActiveRecord::Migration[5.1]
  def change
    create_table :forecasts do |t|
      t.references :farm, foreign_key: true, null: false
      t.references :forecast_type, foreign_key: true, null: false
      t.references :forecast_provider, foreign_key: true, null: false
      t.string :forecast_provider_forecast_ref
      t.datetime :generated_at, null: false
      t.datetime :begins_at, null: false
      t.integer :horizon_minutes, null: false

      t.text :data

      t.timestamps
    end

    add_index :forecasts, [:forecast_provider_forecast_ref, :forecast_provider_id], unique: true,
        name: "forecast_provider_forecast_ref_idx"
  end
end
