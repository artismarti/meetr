class MeetingsController < ApplicationController
  before_action :find_meeting, only:[:show, :edit, :update, :destroy, :existing_invitees, :is_creator]
  before_action :existing_invitees, only:[:edit, :update]

  def show
    @meeting.get_venues(@meeting.midpoint_latitude,@meeting.midpoint_longitude)
  end

  def index
    @user_meetings = UserMeeting.where(user_id: current_user.id)
    @meetings = Meeting.where(id: @user_meetings.map {|um| um.meeting_id})
  end

  def new
    @users = User.all
    @meeting = Meeting.new
  end

  def create
    @users = User.all
    @meeting = Meeting.new(meeting_params(:title, :date_time))
    if @meeting.valid?
      @meeting.save
      creator_user_meeting = UserMeeting.create!(:user_id => params[:meeting][:creator_id], :meeting_id => @meeting.id, :user_status => "created", :start_address => params[:meeting][:start_address])
      creator_user_meeting.get_lat_lng(params[:meeting][:start_address])
      creator_user_meeting.save
      @meeting.update(:midpoint_latitude => creator_user_meeting.start_latitude)
      @meeting.update(:midpoint_longitude => creator_user_meeting.start_longitude)
      creator_user_meeting.save

      params[:meeting][:invitee_ids].each do |i|
        invitee_user_meeting = UserMeeting.create(:user_id => i, :meeting_id => @meeting.id, :user_status => "invited",:start_address => params[:meeting][:start_address])
        invitee_user_meeting.update!(:start_latitude => creator_user_meeting.start_latitude)
        invitee_user_meeting.update!(:start_longitude => creator_user_meeting.start_longitude)
      end

      redirect_to meeting_path(@meeting)
    else
      flash[:errors] = @meeting.errors.full_messages
      render :new
    end
  end

  def edit
    @users = User.all
    @creator = is_creator
  end

  def update
    @meeting.update(meeting_params(:title, :date_time))
    if params[:meeting][:invitee_ids]
      updated_invitees = params[:meeting][:invitee_ids].map(&:to_i)
      new_invitees = []
      deleted_invitees = []
      if @meeting.valid?
        @meeting.save
        @user_meeting= UserMeeting.find_by(meeting_id: @meeting.id, user_id: current_user.id)
        @user_meeting.update(:start_address => params[:meeting][:start_address])
        @user_meeting.get_lat_lng(params[:meeting][:start_address])
        if (updated_invitees - @existing_invitees) == []
          @meeting.recalculate_midpoint
          # @meeting.get_venues(@meeting.midpoint_latitude,@meeting.midpoint_longitude)
          redirect_to meeting_path(@meeting) and return
        else
          new_invitees = updated_invitees - @existing_invitees
          deleted_invitees = @existing_invitees - updated_invitees
          if new_invitees
            new_invitees.each do |ni|

              @user_meeting = UserMeeting.create(:user_id => ni, :meeting_id => @meeting.id, :user_status => "invited", :start_address => params[:meeting][:start_address] )
              @user_meeting.get_lat_lng(params[:meeting][:start_address])
            end
          end
          if deleted_invitees
            deleted_invitees.each do |ni|
              (UserMeeting.where(user_id: ni, meeting_id: @meeting.id, user_status: "invited")).destroy_all
            end
          end
        end
        @meeting.recalculate_midpoint
        redirect_to meeting_path(@meeting)
      else
        flash[:errors] = @meeting.errors.full_messages
        render :edit
      end
    end
  end

  def destroy
    @meeting.destroy
    flash[:success] = "The meeting and all location & meeting data was wiped out"
    redirect_to meetings_path
  end

  private
  def is_creator
    @user_meetings = UserMeeting.where(meeting_id: @meeting)
    creator = false
    @user_meetings.each do |um|
      if um.user_status == "created" && um.user_id == current_user.id
        creator = true
      end
    end
    creator
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

  def existing_invitees
    @user_meetings = UserMeeting.all
    meetings = []
    existing_invitees = []
    meetings = @user_meetings.select{|meetings| meetings.meeting_id == @meeting.id}
    @existing_invitees = meetings.map{|u| u.user_id}
  end

  def meeting_params(*args)
    params.require(:meeting).permit(*args)
  end
end
