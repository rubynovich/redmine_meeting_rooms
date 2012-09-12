class CreateMeetingRooms < ActiveRecord::Migration
  def self.up
    create_table :meeting_rooms do |t|
      t.column :name, :string
      t.column :capacity, :integer
      t.column :is_closed, :boolean
      t.column :start_time, :time
      t.column :end_time, :time
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :meeting_rooms
  end
end
