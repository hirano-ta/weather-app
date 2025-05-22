class WeatherController < ApplicationController
  def index
    weather = Weather.new(city: "tokyo")
    assign_view_variables(weather)
  end

  def search
    input_city = params[:q].presence || "tokyo"
    weather    = Weather.new(city: input_city)
    assign_view_variables(weather)
    render :index
  end

  private

  def assign_view_variables(weather)
    @weather_data = weather.weather_data
    flash.now[:alert] = weather.error_message if weather.error_message.present?
  end
end
