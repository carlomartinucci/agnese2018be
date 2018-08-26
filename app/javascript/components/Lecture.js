import React from "react"
import PropTypes from "prop-types"

const Lecture = ({ lecture = {}, ended = false, answers = {} }) => {
  const {
    title,
    description,
    tutor,
    createdAt,
    questionsCount,
    background,
  } = lecture

  const results = {}
  results.total = questionsCount
  results.right = Object.keys(answers).filter(k => answers[k].isRight).length
  results.wrong = Object.keys(answers).length - results.right
  results.blank = results.total - Object.keys(answers).length
  results.points = (results.right * 1 - results.wrong * 0.2).toFixed(1)

  return <div className="card">
    <div className="card-header">
      {createdAt}, {questionsCount} domande
    </div>

    { false && <img src={background} className='responsive-image card-img-top' alt={title} /> }

    <div className="card-body">
      <h5 className="card-title">
        {title}
      </h5>

      <h6 className="card-subtitle mb-2 text-muted">
        {tutor}
      </h6>

      <p className="card-text">
        {description}
      </p>

      { ended ? <Ended results={results} /> : <Started /> }
    </div>
  </div>
}

const Started = () => <p className="card-text text-center h2">
  Ascolta il tutor: le domande inizieranno tra poco!
</p>

const Ended = ({ results }) => {
  const {
    total,
    right,
    wrong,
    blank,
    points,
  } = results

  return <React.Fragment>
    <p className="card-text text-center">
      La lezione è finita.<br/>
      Hai risposto correttamente a {right} {right === 1 ? 'domanda' : 'domande'},<br/>
      hai sbagliato {wrong} {wrong === 1 ? 'domanda' : 'domande'},<br/>
      hai lasciato in bianco {blank} {blank === 1 ? 'domanda' : 'domande'},<br/>
      per un punteggio di {points} su un massimo di {total}.
    </p>
  </React.Fragment>
}

export default Lecture
