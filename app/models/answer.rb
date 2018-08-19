# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  user_slug     :string
#  question_uuid :string
#  letter        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Answer < ApplicationRecord
  LETTERS = ['a', 'b', 'c', 'd', 'e'].freeze
  belongs_to :question, foreign_key: :question_uuid, primary_key: :uuid

  before_validation :downcase_letter

  validates :user_slug, presence: true
  validates :question, presence: true
  validates :question_uuid, uniqueness: { scope: :user_slug }
  validates :letter, presence: true, inclusion: { in: Answer::LETTERS }

  def right?
    letter == question.right_answer_letter
  end

  def as_react_json
    {
      user_slug: user_slug,
      letter: letter,
      question_uuid: question_uuid,
      is_right: right?
    }
  end

  def self.as_react_json
    current_scope.includes(:question).map { |answer| [answer.question_uuid, answer.as_react_json  ] }.to_h
  end

  private

    def downcase_letter
      self.letter = self.letter.to_s.downcase
    end
end
