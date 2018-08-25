class LivesController < ApplicationController
  before_action :set_live_lecture, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def create
    authorize! :create, LiveLecture
    @live_lecture = LiveLecture.new(params.require(:live_lecture).permit(:lecture_id))
    @live_lecture.state = LiveLecture::STARTED

    if @live_lecture.save
      redirect_to edit_life_path(@live_lecture.uuid), notice: 'Sei LIVE!'
    else
      redirect_to request.referer, alert: 'Impossibile andare LIVE ora.'
    end
  end

  def index
    @live_lectures = LiveLecture.live.with_questions
    # @answers = Answer.where(user_slug: current_user_slug)
  end

  def show
    @answers = Answer.where(user_slug: current_user_slug, question: @live_lecture.lecture.questions)
  end

  def edit
    authorize! :edit, @live_lecture

    @live_lecture_action =
      case @live_lecture.state
      when LiveLecture::STARTED
        'Inizia!'
      when LiveLecture::QUESTION_OPEN
        'Chiudi'
      when LiveLecture::QUESTION_CLOSED
        if @live_lecture.question.last?
          'Concludi'
        else
          'Prossima'
        end
      when LiveLecture::ENDED
        nil
      end
  end

  def update
    authorize! :update, @live_lecture
    if @live_lecture.next
      sleep(2) if Rails.env.development?
      ActionCable.server.broadcast "lives_#{@live_lecture.uuid}", live_lecture: @live_lecture.as_react_json
      flash_message = { notice: 'Avanti!' }
    else
      flash_message = { alert: "C'è stato un errore..." }
    end
    redirect_to edit_life_path(@live_lecture.uuid), flash_message
  end

  def destroy
    authorize! :end, @live_lecture
    @live_lecture.update(state: LiveLecture::ENDED, question: nil)
    redirect_to request.referer, notice: 'LIVE terminato correttamente.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_live_lecture
      @live_lecture = LiveLecture.with_questions.find_by!(uuid: params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to lives_path, alert: 'La lezione è finita. Sei pronto per la prossima?'
    end
end
