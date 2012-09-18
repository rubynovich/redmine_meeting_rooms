class MeetingRoomReserve < ActiveRecord::Base
  unloadable
  
  belongs_to :user
  belongs_to :meeting_room
  
  validates_presence_of :user_id, :meeting_room_id, :subject, 
    :reserve_on, :start_time, :end_time
  
  named_scope :actual, lambda{
    date = Date.today
    time = Time.now
    {
      :conditions => [
        "reserve_on > :date OR (reserve_on = :date AND start_time > :time)", {
          :date => date, 
          :time => time.strftime("%H:%M:%S")}
        ]
    }
  }
  
  named_scope :for_meeting_room, lambda{ |meeting_room_id|
    if meeting_room_id.present?
      {:conditions => {:meeting_room_id => meeting_room_id}}
    end
  }
end
