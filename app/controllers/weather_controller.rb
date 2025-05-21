class WeatherController < ApplicationController
  def index
    # デフォルト表示（東京）
    @city = "tokyo"
    @weather = build_weather_data(@city)
  end

  def search
    @city = params[:q].presence || "tokyo"
    @weather = build_weather_data(@city)
    render :index
  end

  private

  def build_weather_data(city)
    response = WeatherService.new(city).fetch_weather
    data = response.parsed_response

    {
      city_name: data["name"],
      weather_description: data["weather"][0]["description"],
      temperature: kelvin_to_celsius(data["main"]["temp"]).round(1),
      temperature_min: kelvin_to_celsius(data["main"]["temp_min"]).round(1),
      temperature_max: kelvin_to_celsius(data["main"]["temp_max"]).round(1),
      humidity: data["main"]["humidity"],
      datetime: Time.at(data["dt"]).strftime('%Y-%m-%d')
    }
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end
end
