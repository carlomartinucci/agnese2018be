class LecturesController < ApplicationController
  before_action :set_lecture, only: [:edit, :update, :destroy]
  authorize_resource

  # GET /lectures
  # GET /lectures.json
  def index
    @lectures = Lecture.where(user: current_user).order(:delivered_at)
  end

  # GET /lectures/new
  def new
    @lecture = Lecture.new
    @lecture.user = current_user
  end

  # GET /lectures/1/edit
  def edit
  end

  # POST /lectures
  # POST /lectures.json
  def create
    @lecture = Lecture.new(lecture_params)
    @lecture.user = current_user

    if @lecture.save
      redirect_to lectures_path, notice: 'Lecture was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lectures/1
  # PATCH/PUT /lectures/1.json
  def update
    if @lecture.update(lecture_params)
      redirect_to lectures_path, notice: 'Lecture was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def destroy
    @lecture.destroy
    redirect_to lectures_url, notice: 'Lecture was successfully destroyed.'
  end

  private

    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    def lecture_params
      params.require(:lecture).permit(:title, :delivered_at, :tutor, :description, :background)
    end
end
