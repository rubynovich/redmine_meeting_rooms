class MeetingRoomsController < ApplicationController
  unloadable
  layout 'admin'

  before_filter :require_admin

  def index
    @meeting_room = MeetingRoom.new
    @meeting_rooms = MeetingRoom.all(:order => :capacity)
  end
  
  def new
    @meeting_room = MeetingRoom.new
  end
  
  def edit
    @meeting_room = MeetingRoom.find(params[:id])
  end
  
  def show
    @meeting_room = MeetingRoom.find(params[:id])
  end
  
  def update
    @meeting_room = MeetingRoom.find(params[:id])
    if @meeting_room.update_attributes(params[:meeting_room])
      flash[:notice] = l(:notice_successful_update)    
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def create
    @meeting_room = MeetingRoom.new(params[:meeting_room])
    if @meeting_room.save
      flash[:notice] = l(:notice_successful_create)    
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def destroy
    begin
      MeetingRoom.find(params[:id]).destroy
    rescue
      flash[:error] = l(:error_unable_delete_meeting_room)
    else
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :action => 'index'
  end  
end
