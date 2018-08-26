import React from "react"
import PropTypes from "prop-types"
import Lecture from "./Lecture"
import { QuestionAnswered, QuestionOpen, QuestionClosed } from "./Question"
import Results from "./Results"
import { withAnswers } from "./withAnswers"
import { withLiveLectureAndTutorData } from "./withLiveLectureAndTutorData"

const LiveContainer = (props) => {
  const {
    state,
    lecture,
    question,
  } = props.liveLecture

  const answers = props.answers
  const answer = question && answers[question.uuid]
  const isAnswerLoading = question && props.isAnswerLoading
  const setAnswer = question && props.setAnswer

  return <Live
    tutorData={props.tutorData}
    state={state}
    lecture={lecture}
    question={question}
    answers={answers}
    answer={answer}
    isAnswerLoading={isAnswerLoading}
    setAnswer={setAnswer}
  />
}

LiveContainer.propTypes = {
  tutorData: PropTypes.object,
  liveLecture: PropTypes.object.isRequired,
  answers: PropTypes.object.isRequired,
  isAnswerLoading: PropTypes.bool.isRequired,
  setAnswer: PropTypes.func.isRequired,
};

const Live = ({ tutorData, state, lecture, question, answers, answer, isAnswerLoading, setAnswer }) => {
  switch(state) {
    case 'live_lecture.state.started':
      return <Lecture lecture={lecture} />
    case 'live_lecture.state.question_open':
    if (answer) {
      const { isRight, ...answerWithoutIsRight } = answer
      return <QuestionAnswered tutorData={tutorData || {}} question={question} lecture={lecture} answer={answerWithoutIsRight} isAnswerLoading={isAnswerLoading} />
    } else {
      return <QuestionOpen tutorData={tutorData || {}} question={question} lecture={lecture} setAnswer={setAnswer} />
    }
    case 'live_lecture.state.question_closed':
      return <QuestionClosed tutorData={tutorData || {}} question={question} lecture={lecture} answer={answer || {letter: ''}} />
    case 'live_lecture.state.ended':
      return <Lecture lecture={lecture} answers={answers} ended />
      // return <Results />
    default:
  }
}

Live.propTypes = {
  tutorData: PropTypes.object,
  state: PropTypes.string.isRequired,
  lecture: PropTypes.object.isRequired,
  question: PropTypes.object,
  answers: PropTypes.object.isRequired,
  answer: PropTypes.object,
  isAnswerLoading: PropTypes.bool,
  setAnswer: PropTypes.func,
};

export default withLiveLectureAndTutorData(withAnswers(LiveContainer));
