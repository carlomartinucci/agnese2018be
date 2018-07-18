# == Schema Information
#
# Table name: lectures
#
#  id           :integer          not null, primary key
#  title        :string
#  delivered_at :datetime
#  tutor        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  uuid         :string
#

class Lecture < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_one_attached :background

  before_validation :set_uuid

  validates :title, presence: true
  validates :tutor, presence: true
  validates :description, presence: true
  validates :uuid, presence: true, uniqueness: true

  private

    def set_uuid
      tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

      while self.uuid.blank?
        uuid = tokens.sample(6).join
        self.uuid = uuid if Lecture.where(uuid: uuid).none?
      end
    end
end
