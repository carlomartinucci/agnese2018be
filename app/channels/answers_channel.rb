class AnswersChannel < ApplicationCable::Channel
  def subscribed
    puts 'subscribed AnswersChannel'
    stream_from "answers_#{params[:question_uuid]}"
  end
end
