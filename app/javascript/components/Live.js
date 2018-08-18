import React from "react"
import PropTypes from "prop-types"
import Lecture from "./Lecture"
import Question from "./Question"
import Results from "./Results"
import { withAnswers } from "./withAnswers"

class LiveContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      liveLecture: props.liveLecture,
    };
  }

  render() {
    const {
      state,
      lecture,
      question,
    } = this.state.liveLecture

    const answer = this.props.answers[question && question.uuid] || { letter: null }

    return <Live
      state={state}
      lecture={lecture}
      question={question}
      answer={answer}
      answerLoading={this.props.answerLoading}
      setAnswer={question ? this.props.setAnswer : undefined}
    />
  }
}

LiveContainer.propTypes = {
  liveLecture: PropTypes.object.isRequired,
  answers: PropTypes.object.isRequired,
  setAnswer: PropTypes.func.isRequired,
  answerLoading: PropTypes.bool.isRequired,
};

const Live = ({ state, lecture, question, answer, setAnswer }) => {
  switch(state) {
    case 'live_lecture.state.started':
      return <Lecture lecture={lecture} />
    case 'live_lecture.state.question_open':
      return <Question question={question} lecture={lecture} answer={answer} setAnswer={setAnswer} />
    case 'live_lecture.state.question_closed':
      return <Question question={question} lecture={lecture} answer={answer} setAnswer={() => {}} />
    case 'live_lecture.state.ended':
      return <Lecture lecture={lecture} ended />
      // return <Results />
    default:
  }
}

Live.propTypes = {
  state: PropTypes.string.isRequired,
  lecture: PropTypes.object.isRequired,
  question: PropTypes.object,
  answer: PropTypes.object,
  setAnswer: PropTypes.func,
};

export default withAnswers(LiveContainer);
