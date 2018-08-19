import React from "react"
import PropTypes from "prop-types"

const Question = ({ question, lecture, answer, setAnswer, isAnswerLoading, children }) => {
  return <div className="card">
    <div className="card-header">
      {question.position}/{lecture.questionsCount} {lecture.title}
    </div>

    <div className="card-body">
      <h5 className="card-title">
        { question.title }
      </h5>

      { false && <h6 className="card-subtitle mb-2 text-muted"></h6> }

      <p className="card-text">
        { question.description }
      </p>

    </div>

    { children }
  </div>
}

export const QuestionOpen = props => <Question {...props}>
  <div className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      return <a
        key={letter}
        onClick={(_event) => props.setAnswer({ questionUuid: props.question.uuid, letter })}
        className={`list-group-item list-group-item-action`}>
        {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
      </a>
    })}
  </div>
</Question>

export const QuestionAnswered = props => <Question {...props}>
  <ul className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      return <li
        key={letter}
        className={`list-group-item ${props.answer.letter === letter && 'bg-primary'}`}>
        {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
        {props.answer.letter === letter && props.isAnswerLoading && '...loading'}
      </li>
    })}
  </ul>
</Question>

export const QuestionClosed = props => <Question {...props}>
  <ul className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      let successSymbol
      if (props.answer.letter === letter) {
        successSymbol = props.answer.isRight ? 'yes!' : 'no'
      }
      return <li
        key={letter}
        className={`list-group-item ${props.answer.letter === letter && 'bg-primary'}`}>
        {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
        {successSymbol}
      </li>
    })}
  </ul>
</Question>

Question.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  setAnswer: PropTypes.func,
  answer: PropTypes.object,
  isAnswerLoading: PropTypes.bool,
};

QuestionOpen.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  setAnswer: PropTypes.func.isRequired,
};

QuestionAnswered.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  answer: PropTypes.object.isRequired,
  isAnswerLoading: PropTypes.bool.isRequired,
};

QuestionClosed.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  answer: PropTypes.object.isRequired,
};

export default Question
