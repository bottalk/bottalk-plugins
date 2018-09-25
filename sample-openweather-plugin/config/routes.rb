Rails.application.routes.draw do
  get  'weather_plugin/discovery'
  post 'weather_plugin/current'
  post 'weather_plugin/cities'
  post 'weather_plugin/list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
