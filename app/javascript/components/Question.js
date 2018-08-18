import React from "react"
import PropTypes from "prop-types"

const Question = ({ question = {}, lecture = {}, answer = {}, setAnswer }) => {
  const {
    uuid,
    position = 0,
    title,
    description,
    answerA,
    answerB,
    answerC,
    answerD,
    answerE,
  } = question

  const {
    title: lectureTitle,
    questionsCount = 0
  } = lecture

  const {
    isRight,
    letter: answerLetter
  } = answer

  return <div className="card">
    <div className="card-header">
      {position}/{questionsCount} {lectureTitle}
    </div>

    <div className="card-body">
      <h5 className="card-title">
        { title }
      </h5>

      { false && <h6 className="card-subtitle mb-2 text-muted"></h6> }

      <p className="card-text">
        { description }
      </p>

    </div>

    <div className="list-group list-group-flush">
      {['a', 'b', 'c', 'd', 'e'].map(letter => {
        let letterClass = ''
        if (answerLetter && answerLetter === letter && isRight) {
          letterClass += ' bg-success'
        } else if (answerLetter && answerLetter === letter) {
          letterClass += ' bg-danger'
        } else if (answerLetter) {
          letterClass += ' disabled'
        }
        return <a
          key={letter}
          onClick={(_event) => setAnswer({ questionUuid: uuid, letter })}
          className={`list-group-item list-group-item-action${letterClass}`}>
          {letter.toUpperCase()}: { eval(`answer${letter.toUpperCase()}`) }
        </a>
      })}
    </div>
  </div>
}

Question.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  answer: PropTypes.object.isRequired,
  setAnswer: PropTypes.func
};

export default Question
