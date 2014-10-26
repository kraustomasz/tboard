class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :version
      t.string :nick
      t.string :profile_url
      t.datetime :last_check

      t.timestamps
    end
  end
end
