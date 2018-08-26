class PollController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!

  def lives
    live_lecture = LiveLecture.with_questions.find_by!(uuid: params[:uuid])
    render json: { live_lecture: live_lecture.as_react_json }
  end

  def answers
    question = Question.find_by!(uuid: params[:uuid])
    render json: { answers: question.answers.group(:letter).count }
  end
end
