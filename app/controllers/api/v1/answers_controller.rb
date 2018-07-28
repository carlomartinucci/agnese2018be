class API::V1::AnswersController < API::V1::BaseController
  def show
    answer = Answer.find_by question_uuid: params[:id], email: params[:email]
    render json: { answer: answer.try(:letter) }
  end

  def first_or_create
    answer = Answer.where(question_uuid: params[:id], email: params[:email]).first_or_initialize
    answer.update(letter: params[:answer])
    render json: { answer: answer.try(:letter) }
  end
end
