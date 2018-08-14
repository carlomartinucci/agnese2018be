class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!, except: [:home, :googlefbd316a7a778fef4]
  helper_method :current_lectures

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to new_user_session_path, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def home
    redirect_to new_user_session_path if current_user.blank?
  end

  def googlefbd316a7a778fef4
    render layout: false
  end

  private
    def current_lectures
      @current_lectures ||=
        if current_user.present?
          current_user.lectures.where.not(id: nil)
        else
          Lecture.none
        end
    end
end
