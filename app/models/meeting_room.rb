class MeetingRoom < ActiveRecord::Base
  unloadable

  validates_presence_of :name, :capacity, :start_time, :end_time
  validates_uniqueness_of :name

  def meeting_room_reserves
    MeetingRoomReserve.for_meeting_room(self.id).actual_day
  end

  def to_s
    name
  end

  if Rails::VERSION::MAJOR >= 3
    scope :open, where(is_closed: false)
  else
    named_scope :open, lambda{
      {
        :conditions => {
          :is_closed => false
        }
      }
    }
  end
end
