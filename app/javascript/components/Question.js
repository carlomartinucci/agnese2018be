import React from "react"
import PropTypes from "prop-types"

const Question = ({ question, lecture, children }) => {
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

Question.propTypes = {
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
};

export const QuestionOpen = props => <Question {...props}>
  <div className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      let handleClick
      if (!props.tutorData.answers) {
        handleClick = (_event) => props.setAnswer({ questionUuid: props.question.uuid, letter })
      }
      return <a
        key={letter}
        onClick={handleClick}
        className={`list-group-item ${props.tutorData.answers ? '' : 'list-group-item-action'}`}>
        {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
      </a>
    })}
  </div>
  {props.tutorData.answers && <div className="card-footer text-muted text-right">
    {['a', 'b', 'c', 'd', 'e'].reduce((total, letter) => total + (props.tutorData.answers[letter] || 0), 0)}
  </div>}
</Question>

export const QuestionAnswered = props => <Question {...props}>
  <ul className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      let symbol
      if (props.answer.letter === letter) {
        symbol = props.isAnswerLoading && 'sync'
      }
      return <li
        key={letter}
        className={`list-group-item ${props.answer.letter === letter && 'bg-primary'}`}>
        {symbol && <i className="material-icons float-right md-24" style={{margin: '-3px'}}>{symbol}</i>}
        {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
      </li>
    })}
  </ul>
</Question>

export const QuestionClosed = props => <Question {...props}>
  <ul className="list-group list-group-flush">
    {['a', 'b', 'c', 'd', 'e'].map(letter => {
      if (!props.tutorData.answers) {
        return <li key={letter} className={`list-group-item ${props.answer.letter === letter ? (props.answer.isRight ? 'bg-primary' : 'bg-secondary') : ''}`}>
          {props.answer.letter === letter &&
            <i className="material-icons float-right md-24" style={{margin: '-3px'}}>
              {props.answer.isRight ? 'check' : 'close'}
            </i>
          }
          {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
        </li>
      } else if (props.tutorData.answers) {
        const total = ['a', 'b', 'c', 'd', 'e'].reduce((total, letter) => total + (props.tutorData.answers[letter] || 0), 0)
        const perc = parseInt(100 * (props.tutorData.answers[letter] || 0) / total)
        const [full, light] = props.question.rightAnswerLetter === letter ? ['#9c27b0', '#e1bee7'] : ['#ff4081', '#ff80ab']
        return <li key={letter} className={`list-group-item`} style={{
          background: `linear-gradient(to right, ${full} 0%, ${full} ${perc}%, ${light} ${perc}%, ${light} 100%)`
        }}>
          {props.tutorData.answers && <span className={`badge float-right badge-light ${props.question.rightAnswerLetter === letter ? 'text-primary' : 'text-secondary'}`}>
            {props.tutorData.answers[letter] || 0}
            &nbsp;
            <i className="material-icons material-icons-inline">
              {props.question.rightAnswerLetter === letter ? 'check' : 'close'}
            </i>
          </span>}
          {letter.toUpperCase()}: { props.question[`answer${letter.toUpperCase()}`] }
        </li>
      }
    })}
  </ul>
</Question>

QuestionOpen.propTypes = {
  tutorData: PropTypes.object.isRequired,
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  setAnswer: PropTypes.func.isRequired,
};

QuestionAnswered.propTypes = {
  tutorData: PropTypes.object.isRequired,
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  answer: PropTypes.object.isRequired,
  isAnswerLoading: PropTypes.bool.isRequired,
};

QuestionClosed.propTypes = {
  tutorData: PropTypes.object.isRequired,
  question: PropTypes.object.isRequired,
  lecture: PropTypes.object.isRequired,
  answer: PropTypes.object.isRequired,
};

export default Question
