json.extract! question, :id, :lecture_id, :uuid, :title, :answer_a, :answer_b, :answer_c, :answer_d, :answer_e, :right_answer_letter, :created_at, :updated_at
json.url question_url(question, format: :json)
