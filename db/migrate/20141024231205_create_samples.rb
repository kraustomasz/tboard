class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :field1
      t.text :field2

      t.timestamps
    end
  end
end
