import React from "react"
import PropTypes from "prop-types"
import ActionCable from 'actioncable'
import fetch from 'isomorphic-fetch'

import { CABLE_ENDPOINT } from './constants'
import { getDisplayName } from './utils'

const CableApp = {}
CableApp.cable = ActionCable.createConsumer(CABLE_ENDPOINT)
global.CableApp = CableApp
// pass down tutorData
// pass down liveLecture
// listen to active cable to update tutorData when necessary
export const withLiveLectureAndTutorData = Component => {
  class WithLiveLectureAndTutorData extends React.Component {
    constructor(props) {
      super(props);
      this.interval = null
      this.handlePollResponse = this.handlePollResponse.bind(this)
      this.subscribeLivesChannel = this.subscribeLivesChannel.bind(this)
      this.pollLives = this.pollLives.bind(this)
      this.pollAnswers = this.pollAnswers.bind(this)
      this.liveNext = this.liveNext.bind(this)
      this.subscribeAnswersChannel = this.subscribeAnswersChannel.bind(this)
      this.addAnswer = this.addAnswer.bind(this)
      this.countAnswers = this.countAnswers.bind(this)
      this.state = {
        liveLecture: props.liveLecture,
        tutorData: props.tutorData,
      };
    }

    componentDidMount() {
      if (this.state.tutorData) {
        if (this.state.liveLecture.state === 'live_lecture.state.question_open') {
          this.subscribeAnswersChannel()
          this.interval = setInterval(this.pollAnswers, 3 * 1000)
        }
      } else {
        if (this.state.liveLecture.state !== 'live_lecture.state.ended') {
          this.subscribeLivesChannel()
          this.interval = setInterval(this.pollLives, 6 * 1000)
        }
      }
    }

    componentWillUnmount(){
      clearInterval(this.interval)
    }

    handlePollResponse(response) {
      if (response.status >= 400) {
        throw new Error('Cannot poll right now.');
      }
      return response.json()
    }

    pollLives() {
      // console.log('pollLives')
      const options = {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      }

      fetch(`/poll/lives.json?uuid=${this.state.liveLecture.uuid}&t=${Date.now()}`, options)
      .then(this.handlePollResponse)
      .then(this.liveNext)
    }

    subscribeLivesChannel() {
      // const cable = ActionCable.createConsumer(CABLE_ENDPOINT)
      // global.cable = cable

      // console.log('live_lecture_uuid:', this.state.liveLecture.uuid)
      CableApp.cable.subscriptions.create({
        channel: 'LivesChannel',
        live_lecture_uuid: this.state.liveLecture.uuid,
      }, {
        received: this.liveNext
      });
    }

    pollAnswers() {
      if (!this.state.liveLecture.question) return
      // console.log('pollAnswers')
      const options = {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      }

      fetch(`/poll/answers.json?uuid=${this.state.liveLecture.question.uuid}&t=${Date.now()}`, options)
      .then(this.handlePollResponse)
      .then(this.countAnswers)
    }

    subscribeAnswersChannel() {
      if (!this.state.liveLecture.question) return
      // const cable = ActionCable.createConsumer(CABLE_ENDPOINT)
      // global.cable = cable

      // console.log('question_uuid:', this.state.liveLecture.question.uuid)
      CableApp.cable.subscriptions.create({
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

    countAnswers(data) {
      // console.log('countAnswers data:', data)
      this.setState(state => {
        return { tutorData: { ...state.tutorData, answers: data.answers } }
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
