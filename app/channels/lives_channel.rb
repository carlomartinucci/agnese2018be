class LivesChannel < ApplicationCable::Channel
  def subscribed
    puts 'subscribed LivesChannel'
    stream_from "lives_#{params[:live_lecture_uuid]}"
  end
end
