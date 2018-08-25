# == Schema Information
#
# Table name: live_lectures
#
#  id          :integer          not null, primary key
#  lecture_id  :integer
#  question_id :integer
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uuid        :string
#

class LiveLecture < ApplicationRecord
  belongs_to :lecture
  belongs_to :question, optional: true

  STATES = [
    STARTED = 'live_lecture.state.started',
    QUESTION_OPEN = 'live_lecture.state.question_open',
    QUESTION_CLOSED = 'live_lecture.state.question_closed',
    ENDED = 'live_lecture.state.ended',
  ]

  before_validation :set_uuid

  validates :state, presence: true, inclusion: { in: STATES }
  validates :uuid, presence: true, uniqueness: true

  scope :with_questions, -> { includes(:lecture).where.not(lectures: {questions_count: 0}) }
  scope :live, -> { where.not(state: ENDED) }

  def next
    case state
    when STARTED
      question = lecture.questions.order(:position).first
      self.update(state: QUESTION_OPEN, question: question)
    when QUESTION_OPEN
      self.update(state: QUESTION_CLOSED)
    when QUESTION_CLOSED
      next_question = self.question.lower_item
      if next_question.present?
        self.update(state: QUESTION_OPEN, question: next_question)
      else
        self.update(state: ENDED, question: nil)
      end
    when ENDED
      false
    end
  end

  def as_react_json
    case state
    when STARTED
      background = lecture.background.attached? ? Rails.application.routes.url_helpers.url_for(lecture.background) : 'it-doesnt-look-like-anything-to-me-westworld.jpg'
      React.camelize_props(
        uuid: uuid,
        state: state,
        lecture: {
          title: lecture.title,
          description: lecture.description,
          questions_count: lecture.questions_count,
          tutor: lecture.tutor,
          created_at: I18n.l(lecture.created_at, format: :short),
          background: background
        }
      )
    when QUESTION_OPEN
      React.camelize_props(
        uuid: uuid,
        state: state,
        lecture: {
          title: lecture.title,
          questions_count: lecture.questions_count
        },
        question: {
          uuid: question.uuid,
          position: question.position,
          title: question.title,
          description: question.description,
          answer_a: question.answer_a,
          answer_b: question.answer_b,
          answer_c: question.answer_c,
          answer_d: question.answer_d,
          answer_e: question.answer_e
        }
      )
    when QUESTION_CLOSED
      React.camelize_props(
        uuid: uuid,
        state: state,
        lecture: {
          title: lecture.title,
          questions_count: lecture.questions_count
        },
        question: {
          uuid: question.uuid,
          position: question.position,
          title: question.title,
          description: question.description,
          answer_a: question.answer_a,
          answer_b: question.answer_b,
          answer_c: question.answer_c,
          answer_d: question.answer_d,
          answer_e: question.answer_e,
          right_answer_letter: question.right_answer_letter
        }
      )
    when ENDED
      background = lecture.background.attached? ? Rails.application.routes.url_helpers.url_for(lecture.background) : 'it-doesnt-look-like-anything-to-me-westworld.jpg'
      React.camelize_props(
        uuid: uuid,
        state: state,
        lecture: {
          title: lecture.title,
          description: lecture.description,
          questions_count: lecture.questions_count,
          tutor: lecture.tutor,
          created_at: I18n.l(lecture.created_at, format: :short),
          background: background
        }
      )
    end
  end

  private

    def set_uuid
      tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

      while self.uuid.blank?
        uuid = tokens.sample(6).join
        self.uuid = uuid if LiveLecture.where(uuid: uuid).none?
      end
    end
end
