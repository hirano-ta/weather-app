require 'httparty'

class WeatherController < ApplicationController
  def index
    service = WeatherService.new('kawasaki')
    response = service.fetch_weather

    weather_data = response.parsed_response

    @weather = {
      city_name: weather_data['name'],
      weather_description: weather_data['weather'][0]['description'],
      temperature: kelvin_to_celsius(weather_data['main']['temp']).round(1),
      temperature_min: kelvin_to_celsius(weather_data['main']['temp_min']).round(1),
      temperature_max: kelvin_to_celsius(weather_data['main']['temp_max']).round(1),
      humidity: weather_data['main']['humidity'],
    }
  end

  def search
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end

end

class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org'

  def initialize(city)
    api_key = ENV['OPENWEATHER_API_KEY']
    @options = { query: { q: "#{city},jp", appid: api_key, lang: 'ja' } }
  end

  def fetch_weather
    self.class.get("/data/2.5/weather", @options)
  end
end
