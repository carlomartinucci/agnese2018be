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
      this.subscribeLivesChannel = this.subscribeLivesChannel.bind(this)
      this.subscribeAnswersChannel = this.subscribeAnswersChannel.bind(this)
      this.liveNext = this.liveNext.bind(this)
      this.addAnswer = this.addAnswer.bind(this)
      this.state = {
        liveLecture: props.liveLecture,
        tutorData: props.tutorData,
      };
    }

    componentDidMount() {
      if (this.state.tutorData) {
        this.subscribeAnswersChannel()
      } else {
        this.subscribeLivesChannel()
      }
    }

    subscribeLivesChannel() {
      const cable = ActionCable.createConsumer(CABLE_ENDPOINT)

      // console.log('live_lecture_uuid:', this.state.liveLecture.uuid)
      cable.subscriptions.create({
        channel: 'LivesChannel',
        live_lecture_uuid: this.state.liveLecture.uuid,
      }, {
        received: this.liveNext
      });
    }

    subscribeAnswersChannel() {
      if (!this.state.liveLecture.question) return
      const cable = ActionCable.createConsumer(CABLE_ENDPOINT)

      // console.log('question_uuid:', this.state.liveLecture.question.uuid)
      cable.subscriptions.create({
        channel: 'AnswersChannel',
        question_uuid: this.state.liveLecture.question.uuid,
      }, {
        received: this.addAnswer
      });
    }

    liveNext(data) {
      // console.log('liveNext data:', data)
      // console.log('state', this.state)
      this.setState({ liveLecture: data.live_lecture })
    }

    addAnswer(data) {
      // console.log('addAnswer data:', data)
      this.setState(state => {
        if (data.answer.questionUuid !== state.liveLecture.question.uuid) return

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
