class CreateCacheDbs < ActiveRecord::Migration
  def change
    create_table :cache_dbs do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
