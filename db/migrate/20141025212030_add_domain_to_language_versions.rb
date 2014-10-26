class AddDomainToLanguageVersions < ActiveRecord::Migration
  def change
    add_column :language_versions, :domain, :string
  end
end
