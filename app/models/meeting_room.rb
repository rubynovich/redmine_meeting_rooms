class MeetingRoom < ActiveRecord::Base
  unloadable
  
  has_many :reserve_meeting_rooms
  
  named_scope :open, lambda{
    {
      :conditions => {
        :is_closed => false
      }
    }
  }
end
