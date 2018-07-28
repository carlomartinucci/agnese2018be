class API::V1::QuestionsController < API::V1::BaseController
  def show
    question = Question.find_by uuid: params[:id]
    questions = question.lecture.questions.order(:created_at)
    current_index = questions.index(question)
    prev_question = questions[current_index - 1] if current_index.positive?
    next_question = questions[current_index + 1] if current_index < questions.size
    render json: { question: question.as_json, prev: prev_question.as_json, next: next_question.as_json }
  end
end
