class MeetingRoom < ActiveRecord::Base
  unloadable

  validates_presence_of :name, :capacity, :start_time, :end_time
      
  def meeting_room_reserves
    MeetingRoomReserve.for_meeting_room(self.id).actual
  end
  
  named_scope :open, lambda{
    {
      :conditions => {
        :is_closed => false
      }
    }
  }
end
