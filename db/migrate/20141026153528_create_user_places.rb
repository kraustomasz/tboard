class CreateUserPlaces < ActiveRecord::Migration
  def change
    create_table :user_places do |t|
      t.integer :type
      t.integer :place
      t.integer :user_id
      t.integer :answers
      t.integer :questions
      t.integer :points
      t.integer :bests

      t.timestamps
    end
  end
end
