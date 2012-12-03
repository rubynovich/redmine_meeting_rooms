class MeetingRoomReserve < ActiveRecord::Base
  unloadable
  
  belongs_to :user
  belongs_to :meeting_room
  
  validates_presence_of :user_id, :meeting_room_id, :subject, 
    :reserve_on, :start_time, :end_time
  validates_associated :user, :meeting_room
  validates_uniqueness_of :reserve_on, :scope => [:start_time, :end_time, :meeting_room_id]
    
  validate :check_start_time, :check_end_time, :check_reserve_on

  if Rails::VERSION::MAJOR >= 3  
    scope :actual_day, lambda{
      date = Date.today
      time = Time.now
      where("reserve_on > :date OR reserve_on = :date AND end_time > :time", {:date => date, :time => time})
    }
      
    scope :included, lambda{ |date, time|
      if date.present? && time.present?
        where("reserve_on = :date AND start_time < :time AND end_time > :time", {:date => date, :time => time})
      end          
    }  
  
    scope :for_meeting_room, lambda{ |meeting_room_id|
      if meeting_room_id.present?
        where(:meeting_room_id => meeting_room_id)
      end
    }
  else 
    named_scope :actual_day, lambda{
      date = Date.today
      time = Time.now
      {
        :conditions => [
          "reserve_on > :date OR reserve_on = :date AND end_time > :time", {
            :date => date, 
            :time => time}
          ]
      }
    }
      
    named_scope :included, lambda{ |date, time|
      if date.present? && time.present?
        { :conditions => 
            ["reserve_on = :date AND start_time < :time AND end_time > :time",
              {
                :date => date, 
                :time => time
              }
            ]
        }
      end          
    }  
  
    named_scope :for_meeting_room, lambda{ |meeting_room_id|
      if meeting_room_id.present?
        {:conditions => {:meeting_room_id => meeting_room_id}}
      end
    }
  end
    
  def check_start_time
    if self.class.for_meeting_room(self.meeting_room_id).
      included(self.reserve_on, self.start_time).all.any? ||
      self.start_time.seconds_since_midnight < self.meeting_room.start_time.seconds_since_midnight

      errors.add :start_time, :invalid
    end
  end
  
  def check_end_time
    if self.class.for_meeting_room(self.meeting_room_id).
      included(self.reserve_on, self.end_time).all.any? ||
      self.end_time.seconds_since_midnight > self.meeting_room.end_time.seconds_since_midnight ||
      self.end_time.seconds_since_midnight < self.start_time.seconds_since_midnight
      
      errors.add :end_time, :invalid
    end  
  end
  
  def check_reserve_on
    if self.reserve_on < Date.today
      errors.add :reserve_on, :invalid
    end    
  end
end
