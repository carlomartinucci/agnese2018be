# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string
#

class User < ApplicationRecord
  ROLES = [
    USER = 'user'.freeze,
    TUTOR = 'tutor'.freeze,
    ADMIN = 'admin'.freeze
  ].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lectures

  before_validation :set_role

  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: User::ROLES }

  def admin?
    role == User::ADMIN
  end

  def tutor?
    role == User::TUTOR
  end

  def name
    email.split('@').first.titleize
  end

  private

    def set_role
      self.role = User::TUTOR if role.blank?
    end
end
