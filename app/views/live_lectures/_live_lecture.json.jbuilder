json.extract! live_lecture, :id, :lecture_id, :question_id, :state, :created_at, :updated_at
json.url live_lecture_url(live_lecture, format: :json)
