module GoogleDriveDb
	def self.saved_session(path = nil, proxy = nil, client_id = nil, client_secret = nil)

	  if proxy
	    raise(
	        ArgumentError,
	        "Specifying a proxy object is no longer supported. Set ENV[\"http_proxy\"] instead.")
	  end

	  if !client_id && !client_secret
	    client_id = "452925651630-egr1f18o96acjjvphpbbd1qlsevkho1d.apps.googleusercontent.com"
	    client_secret = "1U3-Krii5x1oLPrwD5zgn-ry"
	  elsif !client_id || !client_secret
	    raise(ArgumentError, "client_id and client_secret must be both specified or both omitted")
	  end

	  json_data = CacheDb.where({key: "google_token"})


	  unless json_data.empty? then
	    json_string = json_data.first.value
	    token_data = JSON.parse(json_string)
	  else
	    token_data = nil
	  end

	  client = Google::APIClient.new(
	      :application_name => "google_drive Ruby library",
	      :application_version => "0.3.11"
	  )
	  auth = client.authorization
	  auth.client_id = client_id
	  auth.client_secret = client_secret
	  auth.scope =
	      "https://www.googleapis.com/auth/drive " +
	      "https://spreadsheets.google.com/feeds/ " +
	      "https://docs.google.com/feeds/ " +
	      "https://docs.googleusercontent.com/"
	  auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

	  if token_data

	    auth.refresh_token = token_data["refresh_token"]
	    auth.fetch_access_token!()

	  else

	    $stderr.print("\n1. Open this page:\n%s\n\n" % auth.authorization_uri)
	    $stderr.print("2. Enter the authorization code shown in the page: ")
	    auth.code = $stdin.gets().chomp()
	    auth.fetch_access_token!()
	    token_data = {"refresh_token" => auth.refresh_token}
	    CacheDb.where(key: "google_token").first_or_create.update(value: token_data.to_json)
	   

	  end

	  return GoogleDrive.login_with_oauth(auth.access_token)

	end

end