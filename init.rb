require 'redmine'

Redmine::Plugin.register :redmine_meeting_rooms do
  name 'Reserve meeting rooms'
  author 'Roman Shipiev'
  description 'Redmine plugin for reserve meeting rooms'
  version '0.0.2'
  url 'https://github.com/rubynovich/redmine_meeting_rooms'
  author_url 'http://roman.shipiev.me/'

  permission :view_reserve_meeting_rooms,  :reserve_meeting_rooms => [:index, :show, :edit, :new, :create, :update, :destroy], :public => true

  menu :top_menu, :meeting_room_reserves, {:controller => :meeting_room_reserves, :action => :index}, :caption => :label_meeting_room_reserve_plural, :if => Proc.new{ User.current.logged? }

  menu :admin_menu, :meeting_rooms,
    {:controller => :meeting_rooms, :action => :index},
    :caption => :label_meeting_room_plural, :html => {:class => :enumerations}
end
