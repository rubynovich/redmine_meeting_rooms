if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :meeting_room_reserves
    resources :meeting_rooms
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :meeting_room_reserves
    map.resources :meeting_rooms
  end
end
