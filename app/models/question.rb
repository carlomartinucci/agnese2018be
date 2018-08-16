# == Schema Information
#
# Table name: questions
#
#  id                  :integer          not null, primary key
#  lecture_id          :integer
#  uuid                :string
#  title               :string
#  answer_a            :string
#  answer_b            :string
#  answer_c            :string
#  answer_d            :string
#  answer_e            :string
#  right_answer_letter :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description         :text
#  position            :integer
#

class Question < ApplicationRecord
  belongs_to :lecture, counter_cache: true
  acts_as_list scope: :lecture

  before_validation :set_uuid

  validates :lecture, presence: true
  validates :uuid, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :answer_a, presence: true
  validates :answer_b, presence: true
  validates :answer_c, presence: true
  validates :answer_d, presence: true
  validates :answer_e, presence: true
  validates :right_answer_letter, presence: true, inclusion: { in: %w[a b c d e] }

  def as_react_json
    {
      uuid: uuid,
      position: position,
      title: title,
      description: description,
      lecture: {
        title: lecture.title,
        questions_count: lecture.questions_count
      },
      answer_a: answer_a,
      answer_b: answer_b,
      answer_c: answer_c,
      answer_d: answer_d,
      answer_e: answer_e,
      right_answer_letter: right_answer_letter
    }
  end

  private

    def set_uuid
      tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      lecture_uuid = lecture.try(:uuid) || 'ABSENT'

      while self.uuid.blank?
        uuid = "#{lecture_uuid}-#{tokens.sample(6).join}"
        self.uuid = uuid if Question.where(uuid: uuid).none?
      end
    end
end
