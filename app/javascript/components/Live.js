import React from "react"
import PropTypes from "prop-types"
import Lecture from "./Lecture"
import { QuestionAnswered, QuestionOpen, QuestionClosed } from "./Question"
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

    const answer = question && this.props.answers[question.uuid]
    const isAnswerLoading = question && this.props.isAnswerLoading
    const setAnswer = question && this.props.setAnswer

    return <Live
      state={state}
      lecture={lecture}
      question={question}
      answer={answer}
      isAnswerLoading={isAnswerLoading}
      setAnswer={setAnswer}
    />
  }
}

LiveContainer.propTypes = {
  liveLecture: PropTypes.object.isRequired,
  answers: PropTypes.object.isRequired,
  isAnswerLoading: PropTypes.bool.isRequired,
  setAnswer: PropTypes.func.isRequired,
};

const Live = ({ state, lecture, question, answer, isAnswerLoading, setAnswer }) => {
  switch(state) {
    case 'live_lecture.state.started':
      return <Lecture lecture={lecture} />
    case 'live_lecture.state.question_open':
    if (answer) {
      const { isRight, ...answerWithoutIsRight } = answer
      return <QuestionAnswered question={question} lecture={lecture} answer={answerWithoutIsRight} isAnswerLoading={isAnswerLoading} />
    } else {
      return <QuestionOpen question={question} lecture={lecture} setAnswer={setAnswer} />
    }
    case 'live_lecture.state.question_closed':
      return <QuestionClosed question={question} lecture={lecture} answer={answer} />
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
  isAnswerLoading: PropTypes.bool,
  setAnswer: PropTypes.func,
};

export default withAnswers(LiveContainer);
