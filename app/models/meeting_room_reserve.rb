class MeetingRoomReserve < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :meeting_room

  validates_presence_of :user_id, :meeting_room_id, :subject,
    :reserve_on, :start_time, :end_time
  validates_associated :user, :meeting_room
  validates_uniqueness_of :reserve_on, scope: [:start_time, :end_time, :meeting_room_id]
  validates_uniqueness_of :start_time, scope: [:reserve_on, :meeting_room_id]
  validates_uniqueness_of :end_time, scope: [:reserve_on, :meeting_room_id]

  validate :check_start_time_create, on: :create
  validate :check_end_time_create, on: :create
  validate :check_start_time_update, on: :update
  validate :check_end_time_update, on: :update
  validate :check_meeting_room_hours

  validate :check_reserve_on, if: -> {self.reserve_on && (self.reserve_on < Date.today)}

  if Rails::VERSION::MAJOR >= 3
    scope :actual_day, lambda{
      date = Date.today
      time = Time.now
      where("DATE(reserve_on) > DATE(:date) OR DATE(reserve_on) = DATE(:date) AND TIME(end_time) > TIME(:time)", {date: date, time: time})
    }

    scope :included, lambda{ |date, time|
      if date.present? && time.present?
        where(reserve_on: date).where("TIME(start_time) < TIME(:time) AND TIME(:time) < TIME(end_time)", time: time)
      end
    }

    scope :for_meeting_room, lambda{ |meeting_room_id|
      if meeting_room_id.present?
        where(meeting_room_id: meeting_room_id)
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

private
  def include_time(time)
    (time.seconds_since_midnight < self.meeting_room.start_time.seconds_since_midnight) ||
      (time.seconds_since_midnight > self.meeting_room.end_time.seconds_since_midnight)
  end

  def check_meeting_room_hours
    errors.add :start_time, :invalid if include_time(self.start_time)
    errors.add :end_time, :invalid if include_time(self.end_time)
  end

  def check_start_time_create
    if self.class.for_meeting_room(self.meeting_room_id).included(self.reserve_on, self.start_time).present?
      errors.add :start_time, :invalid
    end
  end

  def check_end_time_create
    if self.class.for_meeting_room(self.meeting_room_id).included(self.reserve_on, self.end_time).present?
      errors.add :end_time, :invalid
    end
  end

  def check_start_time_update
    if self.class.for_meeting_room(self.meeting_room_id).included(self.reserve_on, self.start_time).where("id <> ?", self.id).present?
      errors.add :start_time, :invalid
    end
  end

  def check_end_time_update
    if self.class.for_meeting_room(self.meeting_room_id).included(self.reserve_on, self.end_time).where("id <> ?", self.id).present?
      errors.add :end_time, :invalid
    end
  end

  def check_reserve_on
    errors.add :reserve_on, :invalid
  end
end
