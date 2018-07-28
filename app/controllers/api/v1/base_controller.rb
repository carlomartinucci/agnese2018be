# *some* credits goes to => https://github.com/vasilakisfil/rails_tutorial_api

class API::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :destroy_session
  before_action :html_decode_username

  #rescue_from Exception, with: :internal_server_error!
  # rescue_from CanCan::AccessDenied, with: :unauthorized!
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found!
  # rescue_from ActionController::RoutingError, with: :not_found!
  # rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity!

  protected

    def html_decode_username
      if params[:username].present? && params[:username].is_a?(String)
        params[:username] = params[:username].gsub('%20', ' ')
      end
    end

    def api_error(status = 500, error)
      #unless Rails.env.production?
      #puts error.message if error.respond_to? :message
      logger.info "Error:\nCode: #{status}\nMessage: #{error}\n\nBacktrace:\n#{error.backtrace.join("\n")}"
      #end
      head status: status and return if error.empty?

      render json: jsonapi_format(error).to_json, status: status
    end

    def not_found!(error)
      return api_error(:not_found, error)
    end

    def unauthorized!(error)
      return api_error(:unauthorized, error)
    end

    def bad_request!(error)
      return api_error(:bad_request, error)
    end

    def unprocessable_entity!(error)
      return api_error(:unprocessable_entity, error)
    end

    def internal_server_error!(error)
      return api_error(:internal_server_error, error)
    end

  private

    def destroy_session
      request.session_options[:skip] = true
    end

    def authenticate_user!
      authenticate_or_request_with_http_token do |token, options|
        self.current_user = User.where(authentication_token: token).first
      end
    end

    def jsonapi_format(errors)
      return errors if errors.is_a? String
      return errors.messages

      # errors_hash = {}
      # errors.messages.each do |attribute, error|
      #   array_hash = []
      #   error.each do |e|
      #     array_hash << {attribute: attribute, message: e}
      #   end
      #   errors_hash.merge!({ attribute => array_hash })
      # end

      # return errors_hash
    end
end
