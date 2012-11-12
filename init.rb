require 'redmine'

Redmine::Plugin.register :redmine_meeting_rooms do
  name 'Бронирование переговорных'
  author 'Roman Shipiev'
  description 'В панели администратора вводится перечень переговорных комнат, а в режиме пользователя их уже можно бронировать на определенное время. Удалять и править бронь может только автор брони. Отображаются только актуальные брони.'
  version '0.0.2'
  url 'https://github.com/rubynovich/redmine_meeting_rooms'
  author_url 'http://roman.shipiev.me/'

  permission :view_reserve_meeting_rooms,  :reserve_meeting_rooms => [:index, :show, :edit, :new, :create, :update, :destroy], :public => true  
  
  menu :top_menu, :meeting_room_reserves, {:controller => :meeting_room_reserves, :action => :index}, :caption => :label_meeting_room_reserve_plural, :if => Proc.new{ User.current.logged? }
  
  menu :admin_menu, :meeting_rooms, 
    {:controller => :meeting_rooms, :action => :index},
    :caption => :label_meeting_room_plural, :html => {:class => :enumerations}  
end
