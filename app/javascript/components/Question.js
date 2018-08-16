import React from "react"
import PropTypes from "prop-types"

// TODO: a seconda, mostra QuestionOpen o QuestionClosed
class QuestionContainer extends React.Component {
  render () {
    return (
      <React.Fragment>
        Question: {this.props.question}
      </React.Fragment>
    );
  }
}

// TODO: dividi in QuestionOpen e in QuestionClosed
const Question = ({ question }) => {
  const {
    uuid,
    position,
    title,
    description,
    lecture = {},
    answerA,
    answerB,
    answerC,
    answerD,
    answerE,
    rightAnswerLetter,
    setAnswer = console.log
  } = question
  return <div className="card">
    <div className="card-header">
      {position}/{lecture.questionsCount} {lecture.title}
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
      {['a', 'b', 'c', 'd', 'e'].map(letter =>
        <a key={letter} onClick={() => setAnswer(letter)} className="list-group-item list-group-item-action">
          {letter.toUpperCase()}: { eval(`answer${letter.toUpperCase()}`) }
        </a>
      )}
    </div>
  </div>
}

Question.propTypes = {
  question: PropTypes.object
};

export default Question
