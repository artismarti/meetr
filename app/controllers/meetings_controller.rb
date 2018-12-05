class MeetingsController < ApplicationController
  before_action :find_meeting, only:[:show, :edit, :update, :destroy]

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
    if @meeting.valid?
      @meeting.save
      UserMeeting.update(:user_id => params[:meeting][:creator_id], :meeting_id => @meeting.id, :user_status => "created")
      params[:meeting][:invitee_ids].each do |i|
        UserMeeting.update(:user_id => i, :meeting_id => @meeting.id, :user_status => "invited")
      end
      redirect_to meeting_path(@meeting)
    else
      flash[:errors] = @meeting.errors.full_messages
      render :edit
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

  def meeting_params(*args)
    params.require(:meeting).permit(*args)
  end
  # def creator_params
  #   params.require(:meeting).permit(:creator_id)
  # end
  # def invitee_params
  #   params.require(:meeting).permit(:invitee_id)
  # end

end
