load 'vendor/GoogleDriveDb.rb'
namespace :users do
  desc "TODO"
  task load: :environment do

  	  	p 'test'
		session = GoogleDriveDb.saved_session(nil, nil, Rails.application.config.client_id, Rails.application.config.client_secret)
		ws = session.spreadsheet_by_key(Rails.application.config.users_spreadsheet_key).worksheets[0]
		used_names = []
		for row in 2 .. ws.num_rows
			name = ws[row, 1]
			version = ws[row, 2]
			profile_url = ws[row, 3]
		  	user = User.where({name: name})
		  	used_names.push(name)
		  	if (user.empty?) then
		  		User.create({version: version, name: name, last_check: 0, profile_url: profile_url})
		  		p "adding user " + name
		  	else 
		  		user.first.update({version: version, profile_url: profile_url})
		  		p "user existed " + name
		  	end
		end
		User.find_each do |user|
			unless used_names.include? user.name then
				p "deleting user " + user.name 
				user.destroy
			end
		end 

  end

end
