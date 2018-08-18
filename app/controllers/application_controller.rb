class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!, except: [:home, :googlefbd316a7a778fef4]
  before_action :current_user_slug, except: [:googlefbd316a7a778fef4]
  helper_method :current_lectures
  helper_method :current_user_slug

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

  def kaboom
    raise StandardError, 'Standard Error raised to test exceptions'
  end

  def test
    redirect_to root_path unless current_user&.admin?
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

    def current_user_slug
      @current_user_slug ||=
        begin
          user_slug = cookies.signed[:user_slug]
          if user_slug.blank?
            tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
            user_slug = tokens.sample(10).join

            cookies.signed[:user_slug] = user_slug
          end
          user_slug
        end
    end
end
