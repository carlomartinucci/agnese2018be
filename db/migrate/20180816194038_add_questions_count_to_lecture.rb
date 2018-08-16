class AddQuestionsCountToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :questions_count, :integer, default: 0
    begin
      Lecture.find_each { |l| Lecture.reset_counters l.id, :questions }
    rescue StandardError
      Rails.logger.error 'FAILED TO RESET COUNTERS ON LECTURE QUESTIONS_COUNT'
    end
  end
end
