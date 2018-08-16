class API::V1::QuestionsController < API::V1::BaseController
  def show
    question = Question.find_by uuid: params[:id]
    prev_question = question.higher_item
    next_question = question.lower_item
    render json: { question: question.as_json, prev: prev_question.as_json, next: next_question.as_json }
  end
end
