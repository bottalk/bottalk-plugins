require 'test_helper'

class WeatherPluginControllerTest < ActionDispatch::IntegrationTest
  test "should get discovery" do
    get weather_plugin_discovery_url
    assert_response :success
  end

  test "should get current" do
    get weather_plugin_current_url
    assert_response :success
  end

end
