class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :version
      t.integer :user_id
      t.integer :task_id
      t.datetime :task_created
      t.datetime :created
      t.integer :points
      t.boolean :best

      t.timestamps
    end
  end
end
