require 'redmine'

Redmine::Plugin.register :redmine_meeting_rooms do
  name 'Reserve meeting rooms'
  author 'Roman Shipiev'
  description 'Reserving meeting rooms'
  version '0.1.0'
  url 'https://bitbucket.org/rubynovich/redmine_meeting_rooms'
  author_url 'http://roman.shipiev.me/'

  permission :view_meeting_room_reserves, :meeting_room_reserves => [:index, :show]

  menu :top_menu, :meeting_room_reserves, {:controller => :meeting_room_reserves, :action => :index}, :caption => :label_meeting_room_reserve_plural, :if => Proc.new{ User.current.allowed_to?({:controller => :meeting_room_reserves, :action => :index}, nil, {:global => true}) }

  menu :admin_menu, :meeting_rooms,
    {:controller => :meeting_rooms, :action => :index},
    :caption => :label_meeting_room_plural, :html => {:class => :enumerations}
end
