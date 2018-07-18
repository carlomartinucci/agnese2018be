json.extract! lecture, :id, :title, :delivered_at, :tutor, :description, :created_at, :updated_at
json.url lecture_url(lecture, format: :json)
