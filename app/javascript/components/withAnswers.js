import React from "react"
import PropTypes from "prop-types"
import fetch from 'isomorphic-fetch'

import { getDisplayName } from './utils'

// pass down answers, isAnswerLoading, setAnswer
// setAnswer is a function that:
//   1. update the state with answer and isAnswerLoading
//   2. post the answer to /answers
//   3. returns ok or error
//   4. reupdate answers
export const withAnswers = Component => {
  // ...and returns another component...
  class WithAnswers extends React.Component {
    constructor(props) {
      super(props);
      this.setAnswer = this.setAnswer.bind(this);
      this.postAnswer = this.postAnswer.bind(this);
      this.state = {
        answers: props.answers,
        isAnswerLoading: false,
      };
    }

    setAnswer(answer) {
      this.setState(state => ({
        answers: { ...state.answers, [answer.questionUuid]: answer },
        isAnswerLoading: true,
      }), () => this.postAnswer(answer))
    }

    postAnswer(answer) {
      const body = JSON.stringify({
        answer: {
          question_uuid: answer.questionUuid,
          letter: answer.letter
        }
      })

      const options = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body
      }

      fetch('/answers.json', options)
      .then(response => {
        if (response.status >= 400) {
          return { result: 'error', message: `Server responded with ${response.status}. :( Please refresh the page and retry, or contact an admin.` }
        }
        return response.json()
      })
      .then(json => {
        if (!json){
          this.setState({
            isAnswerLoading: false,
            message: "Could not obtain an answer from the server. :( Please refresh the page and retry, or contact an admin.",
          })
        } else if (json.result === 'error') {
          this.setState({
            answers: json.answers,
            isAnswerLoading: false,
            message: json.message,
          })
        } else if (json.result === 'success') {
          this.setState({
            answers: json.answers,
            isAnswerLoading: false,
            message: json.message,
          })
        }
      })
    }

    render() {
      const { answers, ...passThroughProps } = this.props;
      const injectedAnswers = this.state.answers;

      return (
        <Component
          answers={injectedAnswers}
          isAnswerLoading={this.state.isAnswerLoading}
          setAnswer={this.setAnswer}
          {...passThroughProps}
        />
      );
    }
  };

  WithAnswers.displayName = `WithAnswers(${getDisplayName(Component)})`;

  return WithAnswers
}
