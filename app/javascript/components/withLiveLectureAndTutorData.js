import React from "react"
import PropTypes from "prop-types"
import ActionCable from 'actioncable'

import { CABLE_ENDPOINT } from './constants'
import { getDisplayName } from './utils'

// pass down tutorData
// pass down liveLecture
// listen to active cable to update tutorData when necessary
export const withLiveLectureAndTutorData = Component => {
  class WithLiveLectureAndTutorData extends React.Component {
    constructor(props) {
      super(props);
      this.addAnswer = this.addAnswer.bind(this)
      this.state = {
        liveLecture: props.liveLecture,
        tutorData: props.tutorData,
      };
    }

    componentDidMount() {
      if (!this.state.tutorData) return
      if (!this.state.liveLecture.question) return
      const cable = ActionCable.createConsumer(CABLE_ENDPOINT)

      console.log('question_uuid:', this.state.liveLecture.question.uuid)
      cable.subscriptions.create({
        channel: 'AnswersChannel',
        question_uuid: this.state.liveLecture.question.uuid,
      }, {
        received: this.addAnswer
      });
    }

    addAnswer(data) {
      console.log('addAnswer', data)
      this.setState(state => {
        if (data.answer.question_uuid !== state.liveLecture.question.uuid) return

        const letter = data.answer.letter
        const answers = { ...state.tutorData.answers }
        answers[letter] || (answers[letter] = 0)
        answers[letter] += 1
        return { tutorData: { ...state.tutorData, answers }}
      })
    }

    render() {
      const { liveLecture, tutorData, ...passThroughProps } = this.props;
      const injectedLiveLecture = this.state.liveLecture;
      const injectedTutorData = this.state.tutorData;

      return (
        <Component
          liveLecture={injectedLiveLecture}
          tutorData={injectedTutorData}
          {...passThroughProps}
        />
      );
    }
  };

  WithLiveLectureAndTutorData.displayName = `WithLiveLectureAndTutorData(${getDisplayName(Component)})`;

  return WithLiveLectureAndTutorData
}
