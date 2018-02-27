class CreateFarms < ActiveRecord::Migration[5.1]
  def change
    create_table :farms do |t|
      t.string :name, null: false
      t.references :farm_provider, foreign_key: true, null: false
      t.string :farm_provider_ref
      t.float :lat, null: false
      t.float :lng, null: false
      t.float :capacity_mw

      t.timestamps
    end

    add_index :farms, [:farm_provider_ref, :farm_provider_id], unique: true
  end
end
