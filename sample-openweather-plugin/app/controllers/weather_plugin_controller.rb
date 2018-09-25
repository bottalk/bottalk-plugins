require 'open_weather'
require 'geocoder'
require 'rubygems'
require 'json'

class WeatherPluginController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_token

  def discovery

    @discovery = {
      service: 'OpenWeather Plugin for BotTalk',
      description: 'Wrapping the OpenWeather API and giving it as the BotTalk actions',
      actions: {
        current: {
          endpoint: '/weather_plugin/current',
          description: 'Current weather in the city',
          params: {
            city: 'The name of the city',
            units: 'The measurements units. For Fahrenheit use units=imperial, for Celsius use units=metric'
          },
          returns: {
            temp: 'Current temperature',
            pressure: 'Current pressure',
            humidity: 'Current humidity',
            temp_min: 'Minimal temperature',
            temp_max: 'Maximum temperature'
          }
        },
        cities: {
          endpoint: '/weather_plugin/cities',
          description: 'Get the list of cities - just a shortcut',
          params: {
            cities: 'An array of city names'
          }
        },
        list: {
          endpoint: '/weather_plugin/list',
          description: 'Completely replaces output and sends it directly to smart assistant. Demostrated here is the ListTemplate2 for Alexa'
        }
      }
    }

    render json: @discovery
  end

  def current

    city = params[:city]
    units = params[:units]

    results = Geocoder.search(city)
    coords = results.first.coordinates

    options = { units: units, APPID: Rails.application.credentials.openweather[:appid] }
    @weather = OpenWeather::Current.geocode(coords[0], coords[1], options)

    render json: @weather['main']
  end

  def cities

    cities = params[:cities]

    output_cities = []
    cities.each do |city|
      output_cities.push title: city
    end

    output = {
      inject: {
        'payload.google.richResponse.suggestions': output_cities
      }
    }

    render json: output

  end

  def list

    @@data = JSON.parse(File.read("public/list-output.json"))

    output = {
      output: @@data
    }

    render json: output
  end

private
def check_token
  token = params[:token]

  if token != 'asdf'
    return render json: {status: "error", code: 3000, message: "Your token does not match the one you provided in BotTalk"}
  end
end

end
