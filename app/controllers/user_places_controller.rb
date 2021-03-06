require 'yaml'
class UserPlacesController < ApplicationController
	def index
		@ranking = YAML.load(CacheDb.where({key: 'sorted'}).first.value)
		users_list = User.all
		@users = {}
		users_list.each do |user|
			@users[user.id] = user
		end
		# todo fetch from config
		@buckets = [7, 30, 90]
	end
end
