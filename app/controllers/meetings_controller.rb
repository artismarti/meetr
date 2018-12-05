class MeetingsController < ApplicationController
  before_action :find_meeting, only:[:show, :edit, :update, :destroy, :existing_invitees]
  before_action :existing_invitees, only:[:edit, :update]

  def show
    end

  def index
    @meetings = Meeting.all
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
      UserMeeting.create!(:user_id => params[:meeting][:creator_id], :meeting_id => @meeting.id, :user_status => "created")
      params[:meeting][:invitee_ids].each do |i|
        UserMeeting.create(:user_id => i, :meeting_id => @meeting.id, :user_status => "invited")
      end
      redirect_to meeting_path(@meeting)
    else
      flash[:errors] = @meeting.errors.full_messages
      render :new
    end
  end

  def edit
    @users = User.all
  end

  def update
    @meeting.update(meeting_params(:title, :date_time))
    if params[:meeting][:invitee_ids]
      updated_invitees = params[:meeting][:invitee_ids].map(&:to_i)
      new_invitees = []
      deleted_invitees = []
      if @meeting.valid?
        @meeting.save
        if (updated_invitees - @existing_invitees) == []
          redirect_to meeting_path(@meeting) and return
        else
          new_invitees = updated_invitees - @existing_invitees
          deleted_invitees = @existing_invitees - updated_invitees

          if new_invitees
            new_invitees.each do |ni|
              UserMeeting.create(:user_id => ni, :meeting_id => @meeting.id, :user_status => "invited")
            end
          end
          if deleted_invitees
            deleted_invitees.each do |ni|
              (UserMeeting.where(user_id: ni, meeting_id: @meeting.id, user_status: "invited")).destroy_all
            end
          end
        end
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
