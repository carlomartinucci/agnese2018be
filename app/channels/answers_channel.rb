class AnswersChannel < ApplicationCable::Channel
  def subscribed
    puts 'subscribed AnswersChannel'
    stream_from 'answers'
  end
end
