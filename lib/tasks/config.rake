require "google/api_client"
require "google_drive"
require "retriable"

namespace :config do
  desc "Loads config from a spreadsheet"
  task load: :environment do
  		p 'test'
		session = GoogleDrive.saved_session(nil, nil, Rails.application.config.client_id, Rails.application.config.client_secret)
		ws = session.spreadsheet_by_key(Rails.application.config.config_spreadsheet_key).worksheets[0]
		LanguageVersion.delete_all
		for row in 2 .. ws.num_rows
		  languageVersion = LanguageVersion.create(name: ws[row, 1], task_url: ws[row, 2], domain: ws[row, 3])
		  unless languageVersion.nil? then
		  	p languageVersion
		  end
		end

  end
end
