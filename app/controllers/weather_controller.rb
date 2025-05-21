class WeatherController < ApplicationController
  def index
    service = WeatherService.new('tokyo')
    response = service.fetch_weather
    weather_data = response.parsed_response

    @weather = {
      city_name: weather_data['name'],
      weather_description: weather_data['weather'][0]['description'],
      temperature: kelvin_to_celsius(weather_data['main']['temp']).round(1),
      temperature_min: kelvin_to_celsius(weather_data['main']['temp_min']).round(1),
      temperature_max: kelvin_to_celsius(weather_data['main']['temp_max']).round(1),
      humidity: weather_data['main']['humidity'],
      datetime: Time.at(weather_data['dt']).strftime('%Y-%m-%d')
    }
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end
end
