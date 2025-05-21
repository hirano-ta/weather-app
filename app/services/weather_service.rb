require 'httparty'
require_relative 'weather_service_interface'

class WeatherService
  include HTTParty
  include WeatherServiceInterface

  base_uri 'https://api.openweathermap.org'

  def initialize(city)
    api_key = ENV['OPENWEATHER_API_KEY']
    @options = {
      query: {
        q: "#{city},jp",
        appid: api_key,
        lang: 'ja'
      }
    }
  end

  def fetch_weather
    self.class.get("/data/2.5/weather", @options)
  end
end
