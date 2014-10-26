class AddBrainlyUserIdToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :brainly_user_id, :integer
  end
end
