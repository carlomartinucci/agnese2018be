class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update]
  protect_from_forgery with: :null_session, only: [:create]

  # lecture_uuid
  # question_uuid
  # user_uid

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # POST /answers
  # POST /answers.json
  def create
    sleep(rand(1..5)) if Rails.env.development?
    answer = Answer.new(params.require(:answer).permit(:question_uuid, :letter))
    answer.user_slug = current_user_slug
    saved = answer.save
    answers = Answer.where(user_slug: current_user_slug).as_react_json

    respond_to do |format|
      if saved
        message = 'Risposta registrata correttamente.'
        # Notify tutor
        ActionCable.server.broadcast 'answers', answer: answer.as_react_json
        format.html { redirect_to lives_path(@live_lecture), notice: message }
        format.json { render json: { result: :success, message: message, answers: answers } }
      else
        message = answer.errors.full_messages.join('. ')
        format.html { redirect_to lives_path(@live_lecture), alert: message }
        format.json { render json: { result: :error, message: message, answers: answers } }
      end
    end
  rescue ActiveRecord::StatementInvalid, StandardError => e
    answers = Answer.where(user_slug: current_user_slug).as_react_json

    respond_to do |format|
      format.html { redirect_to lives_path(@live_lecture), alert: e.message }
      format.json { render json: { result: :error, message: e.message, answers: answers } }
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:user_uid, :question_uuid, :letter)
    end
end
