class API::V1::LecturesController < API::V1::BaseController
  def index
    render json: Lecture.order(:created_at).as_json(methods: [:date, :image])
  end

  def show
    lecture = Lecture.find_by uuid: params[:id]
    render json: { lecture: lecture.as_json(methods: [:date, :image]), questions: lecture.questions.as_json }
  end
end
