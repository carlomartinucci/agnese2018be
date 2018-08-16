class LiveLecturesController < ApplicationController
  before_action :set_live_lecture, only: [:show, :update]

  # POST /live_lectures
  # POST /live_lectures.json
  def create
    @live_lecture = LiveLecture.new(live_lecture_params)
    @live_lecture.state = LiveLecture::STARTED

    if @live_lecture.save
      redirect_to @live_lecture, notice: 'Sei LIVE!'
    else
      redirect_to request.referer, alert: 'Impossibile andare LIVE ora.'
    end
  end

  # GET /live_lectures/1
  # GET /live_lectures/1.json
  def show
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

  # PATCH/PUT /live_lectures/1
  # PATCH/PUT /live_lectures/1.json
  def update
    flash_message =
      if @live_lecture.next
        { notice: 'Avanti!' }
      else
        { alert: "C'è stato un errore..." }
      end
    redirect_to @live_lecture, flash_message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_live_lecture
      @live_lecture = LiveLecture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def live_lecture_params
      params.require(:live_lecture).permit(:lecture_id)
    end
end
