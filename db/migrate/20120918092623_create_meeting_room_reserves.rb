class CreateMeetingRoomReserves < ActiveRecord::Migration
  def self.up
    create_table :meeting_room_reserves do |t|
      t.column :user_id, :integer
      t.column :subject, :string
      t.column :meeting_room_id, :integer
      t.column :reserve_on, :date
      t.column :start_time, :time
      t.column :end_time, :time
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :meeting_room_reserves
  end
end
