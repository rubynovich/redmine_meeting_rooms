require 'redmine'

Redmine::Plugin.register :redmine_meeting_rooms do
  name 'Reserve meeting rooms'
  author 'Roman Shipiev'
  description 'Reserving meeting rooms'
  version '0.1.0'
  url 'https://bitbucket.org/rubynovich/redmine_meeting_rooms'
  author_url 'http://roman.shipiev.me/'

  permission :view_meeting_room_reserves, meeting_room_reserves: [:index, :show]

  Redmine::MenuManager.map :top_menu do |menu|

    unless menu.exists?(:internal_intercourse)
      menu.push( :internal_intercourse, "#",
                 after: :public_intercourse,
                 parent: :top_menu,
                 caption: :label_internal_intercourse_menu
               )
    end

    menu.push( :meeting_room_reserves, {controller: :meeting_room_reserves, action: :index},
               parent: :internal_intercourse,
               caption: :label_meeting_room_reserve_plural,
               if: ->{ User.current.allowed_to?(:view_meeting_room_reserves, nil, global: true) }
             )

  end

  menu(:admin_menu, :meeting_rooms,
       {controller: :meeting_rooms, action: :index},
       caption: :label_meeting_room_plural,
       html: {class: :enumerations} )
end
