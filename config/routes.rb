if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :reserve_meeting_rooms
    resources :meeting_rooms
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :reserve_meeting_rooms
    map.resources :meeting_rooms
  end
end
