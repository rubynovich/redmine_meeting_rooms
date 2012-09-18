class MeetingRoomReservesController < ApplicationController
  unloadable

  def index
    @meeting_room_reserve = MeetingRoomReserve.new(params[:meeting_room_reserve])    
  end
  
  def new
    @meeting_room_reserve = MeetingRoomReserve.new(params[:meeting_room_reserve])
  end
  
  def create
    @meeting_room_reserve = MeetingRoomReserve.new(params[:meeting_room_reserve])
    if @meeting_room_reserve.save
      flash[:error] = l(:notice_successful_create)
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
    @meeting_room = MeetingRoomReserve.find(params[:id])  
  end
  
  def show
    @meeting_room = MeetingRoomReserve.find(params[:id])
  end
  
  def update
    @meeting_room_reserve = MeetingRoom.find(params[:id])
    if @meeting_room_reserve.update_attributes(params[:meeting_room_reserve])
      flash[:notice] = l(:notice_successful_update)    
      redirect_to :action => :index
    else
      render :action => :edit
    end  
  end
  
  def destroy
    begin
      MeetingRoomReserve.find(params[:id]).destroy
    rescue
      flash[:error] = l(:error_unable_delete_meeting_room_reserve)
    else
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :action => :index
  end
end
