class WelcomeController < ApplicationController
  def test
  	response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/GA/Atlanta.json")

  	@location = response["location"]["city"]
  	@temp_f = response["current_observation"]["temp_f"]
  	@temp_c = response["current_observation"]["temp_c"]
  	@weather_icon = response["current_observation"]["icon_url"]
  	@weather_words = response["current_observation"]["weather"]
  	@forecast_link = response["current_observation"]["forecast_url"] 
  	@real_feel = response["current_observation"]["feelslike_f"]
  end


  def index
  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)
		@states.sort!


		if params[:city] != nil

			location_exists = false
			Location.all.each do |location|
				if params[:city] == location.city && params[:state] == location.state
					location_exists = true
				end
			end

			if location_exists == false
				temp_arr = params[:city].split
				temp_arr.each do |x|
					x.capitalize!
				end

				params[:city] = temp_arr.join(" ")

				Location.create(city: params[:city], state: params[:state])
			end

			city = params[:city].gsub(" ", "_")

			response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{city}.json")

	  	@results = {
				location: response["location"]["city"],
				temp_f: response["current_observation"]["temp_f"],
		  	temp_c: response["current_observation"]["temp_c"],
		  	weather_icon: response["current_observation"]["icon_url"],
		  	weather_words: response["current_observation"]["weather"],
		  	forecast_link: response["current_observation"]["forecast_url"], 
		  	real_feel: response["current_observation"]["feelslike_f"],
			}
	  end

	  @locations = Location.order(:city)

  end
end
