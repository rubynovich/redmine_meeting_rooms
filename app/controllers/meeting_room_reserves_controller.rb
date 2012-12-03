class MeetingRoomReservesController < ApplicationController
  unloadable

  before_filter :author_required, :only => [:edit, :update, :destroy, :show]
  before_filter :new_meeting_room_reserve, :only => [:new, :create]
  before_filter :find_meeting_room_reserve, :only => [:edit, :show, :update, :destroy]

  def index
    @meeting_rooms = MeetingRoom.open.all(:order => :capacity)
  end
  
  def new
    @meeting_rooms = MeetingRoom.open.all(:order => :capacity)    
  end
  
  def create
    @meeting_room_reserve.user = User.current
    if @meeting_room_reserve.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def show
  end
  
  def update
    if @meeting_room_reserve.update_attributes(params[:meeting_room_reserve])
      flash[:notice] = l(:notice_successful_update)    
      redirect_to :action => :index
    else
      render :action => :edit
    end  
  end
  
  def destroy
    begin
      @meeting_room_reserve.destroy
    rescue
      flash[:error] = l(:error_unable_delete_meeting_room_reserve)
    else
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :action => :index
  end
  
  private
    def author_required
      (render_403; return false) unless User.current == MeetingRoomReserve.find(params[:id]).user
    end
    
    def new_meeting_room_reserve
      @meeting_room_reserve = MeetingRoomReserve.new(params[:meeting_room_reserve])    
    end
    
    def find_meeting_room_reserve
      @meeting_room_reserve = MeetingRoomReserve.find(params[:id])    
    end    
end
