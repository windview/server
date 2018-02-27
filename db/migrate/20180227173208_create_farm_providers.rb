class CreateFarmProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :farm_providers do |t|
      t.string :name, null: false
      t.string :label, null: false

      t.timestamps
    end

    add_index :farm_providers, :name, unique: true
    add_index :farm_providers, :label, unique: true
  end
end
