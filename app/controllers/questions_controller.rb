class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :move]
  before_action :set_lecture, only: [:index, :new, :create]

  # GET /questions
  # GET /questions.json
  def index
    @questions = @lecture.questions.order(:position)
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  def move
    case params[:where]
    when 'higher'
      @question.move_higher
    when 'lower'
      @question.move_lower
    end

    redirect_to lecture_questions_path(@question.lecture)
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.lecture = @lecture

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_question
      @question = Question.find(params[:id])
    end

    def set_lecture
      @lecture = Lecture.find(params[:lecture_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description, :answer_a, :answer_b, :answer_c, :answer_d, :answer_e, :right_answer_letter)
    end
end
