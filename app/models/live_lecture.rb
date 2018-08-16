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

  validates :state, presence: true, inclusion: { in: STATES }

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
      {
        state: state,
        lecture: {
          title: lecture.title,
          questions_count: lecture.questions_count
        }
      }
    when QUESTION_OPEN
      {
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
      }
    when QUESTION_CLOSED
      {
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
      }
    when ENDED
      {
        state: state,
        lecture: {
          title: lecture.title,
          questions_count: lecture.questions_count
        }
      }
    end
  end
end
