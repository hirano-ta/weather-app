class Weather
  include ActiveModel::Model
  include HTTParty

  base_uri "https://api.openweathermap.org"

  attr_accessor :city, :weather_data, :error_message

  validates :city,
            presence: { message: "^都市名を入力してください" },
            format:   { with: /\A[a-zA-Z\s]+\z/,
                        message: "^都市名は英字のみで入力してください" }

  def initialize(attributes = {})
    super
    @city = (@city || "").strip.downcase
    @weather_data = nil
    @error_message = nil

    valid? ? fetch_weather_data : build_error_from_validation
  end

  private

  def fetch_weather_data
    response = self.class.get("/data/2.5/weather",
                              query: { q: "#{city},jp",
                                       appid: ENV["OPENWEATHER_API_KEY"],
                                       lang: "ja" })

    if response.code == 200 && response.parsed_response.present?
      parse_response(response.parsed_response)
    else
      @error_message = "天気情報の取得に失敗しました。"
    end
  rescue HTTParty::Error, SocketError => e
    Rails.logger.error("Weather API error: #{e.message}")
    @error_message = "天気情報の取得に失敗しました。"
  end

  def parse_response(data)
    @weather_data = {
      city_name:          data["name"],
      weather_description: data["weather"][0]["description"],
      temperature:         kelvin_to_celsius(data["main"]["temp"]).round(1),
      temperature_min:     kelvin_to_celsius(data["main"]["temp_min"]).round(1),
      temperature_max:     kelvin_to_celsius(data["main"]["temp_max"]).round(1),
      humidity:            data["main"]["humidity"],
      datetime:            Time.at(data["dt"]).strftime("%Y-%m-%d")
    }
  end

  def build_error_from_validation
    @error_message = errors.full_messages.join(", ") 
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end
end
