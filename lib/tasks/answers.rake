require 'nokogiri'
require 'open-uri'
require 'set'
require 'json'
require 'net/http'
require 'pp'
require 'yaml'


namespace :answers do
  desc "TODO"
  @langUrls = {}
  task update_all: :environment do
  	LanguageVersion.find_each do |langVer|
  		@langUrls[langVer.name] = [langVer.domain, langVer.task_url]
  	end


  	User.find_each do |user|
  		if (DateTime.current.to_i - user.last_check.to_i > Rails.application.config.last_check_freshness) then
  			p "Has to refresh: " + user.name
  			refresh_user user
  			#user.update(last_check: DateTime.current)
  		else
  			p "Fresh enough: " + user.name
  		end
  	end

  end



  def add_tasks_to_set(set, page) 
  	p "called for page size: " + page.to_s.length.to_s
  
  	urls = page.css('#tasks-solved > ol > li > div.task-content > a').each do |node|
  		url = node.attr('href').to_s
  		task_id = url.split(/\//)[2]
  		task_id = task_id.split(/\?/)[0]
  		set.add(task_id.to_i)
  	end
  end


  def refresh_user(user)
  	user_id = user.profile_url.split(/\-/)[-1]
  	task_ids = Set.new
  	if user.profile_url.empty?
  		p "user profile not filled " + user.name
  		return false
  	end
  	p "Url for user is: " + user.profile_url
  	page = Nokogiri::HTML(open(user.profile_url + '/solved')) 
  	if page.nil? then
  		p "problem getting " + user.profile_url
  		return false
  	end

  	

	puts page.class   # => Nokogiri::HTML::Document
	nick = page.css('#main-left > div.personal_info > div.header > div.info > div.info_top > span.ranking > h2 > a').text
	p "user nick is " + nick
	user.update(nick: nick, last_check: DateTime.current)

	add_tasks_to_set(task_ids, page)
	if task_ids.length == 0 then
		p "user " + user.name  + " 0 questions"
		return true
	end

	# iterate next pages
	max_page = 10
	cur_page = 2
	begin
		cur_task_count = task_ids.count
		url = user.profile_url + "/solved/" + cur_page.to_s
		page = Nokogiri::HTML(open(url)) 

		add_tasks_to_set(task_ids, page)

		cur_page += 1
	end while task_ids.count > cur_task_count && cur_page < max_page


	task_ids.each do |task_id|
		refresh_answer(user.version, task_id, user.id, user_id)
	end

  end

  def refresh_answer(lang_version_string, task_id, user_id, brainly_user_id)
  	answer = Answer.where({version: lang_version_string, task_id: task_id, user_id: user_id})
  	if answer.empty? then
  		p "fetching answer for task_id: " + task_id.to_s + " and user_id: " + brainly_user_id

  		url = 'http://' + lang_version_string + '.data.api.z-dn.net/api/18/api_tasks/main_view/' + task_id.to_s
  		p url
  		resp = Net::HTTP.get_response(URI.parse(url))
  	 	content = resp.body
  		data = JSON.parse(content)

  		if (data['success'] != true) then
  			p "wrong response"
  			return false
  		end

  		found = false
  		data['data']['responses'].each do |response|
  			#p response
  			if (response['user_id'].to_i == brainly_user_id.to_i) then
  				created = response['created']
  				datetime_created = DateTime.parse(created)
  				Answer.create({
  					created: created,
  					user_id: user_id,
  					brainly_user_id: brainly_user_id,
  					task_id: task_id,
  					version: lang_version_string,
  				})
  				found = true
  				break
  			end

  		end

  		unless found then
  			p "Response not found"
  			p data
  		end


  	else
  		p "answer already in database, for task_id: " + task_id.to_s + " and user_id: " + brainly_user_id
  	end
  end

  task calculate_user_places: :environment do
  	ranking = {}
  	buckets = Rails.application.config.buckets
  	User.find_each do |user|
  		ranking[user.id] = {}
  		buckets.each do |bucket|
  			ranking[user.id][bucket] = {
  				answers: 0,
  				questions: 0,
  				points: 0,
  				bests: 0
  			}
  		end
  	end
  	Answer.find_each do |answer| 
  		unless ranking.include? answer.user_id then
  			p "nonexistant user found " + answer.user_id
  			next
  		end
  		buckets.each do |bucket|
  			if DateTime.current.to_i - answer.created.to_i < bucket * 86400 then
  				p "answer to: " + answer.task_id.to_s + ', created on: ' + answer.created.to_s + ' falls into the bucket: ' + bucket.to_s
  				ranking[answer.user_id][bucket][:answers] += 1
  			else
  				p "answer to: " + answer.task_id.to_s + ', created on: ' + answer.created.to_s + ' does not fall into the bucket: ' + bucket.to_s
  			end
  		end
  	end
  	sorted = ranking.sort_by { |k, v| [-v[buckets[0]][:answers], -v[buckets[1]][:answers], -v[buckets[2]][:answers] ]}
  	pp sorted
  	File.open('db/sorted.yml', 'w') {|f| f.write(YAML.dump(sorted)) }
  end

end
