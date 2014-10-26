class CreateLanguageVersions < ActiveRecord::Migration
  def change
    create_table :language_versions do |t|
      t.string :name
      t.string :task_url

      t.timestamps
    end
  end
end
