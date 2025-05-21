module WeatherServiceInterface
  def fetch_weather
    raise NotImplementedError, "#{self.class} must implement fetch_weather"
  end
end
