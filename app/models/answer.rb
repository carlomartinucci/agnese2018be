# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  email         :string
#  question_uuid :string
#  letter        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Answer < ApplicationRecord
  LETTERS = ['a', 'b', 'c', 'd', 'e'].freeze

  before_validation :downcase_letter

  validates :email, presence: true
  validates :question_uuid, presence: true, uniqueness: { scope: :email }
  validates :letter, presence: true, inclusion: { in: Answer::LETTERS }

  private

    def downcase_letter
      self.letter = self.letter.to_s.downcase
    end
end
