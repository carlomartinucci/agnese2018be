import React from "react"
import PropTypes from "prop-types"

const Lecture = ({ lecture = {}, ended = false }) => {
  const {
    title,
    description,
    tutor,
    createdAt,
    questionsCount,
    background,
  } = lecture

  return <div className="card">
    <div className="card-header">
      {createdAt}, {ended ? '' : '-/'} {questionsCount} domande
    </div>

    <img src={background} className='responsive-image card-img-top' alt={title} />

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

      <p className="card-text text-center">
      { ended
        ? 'La lezione è finita. Sei pronto per la prossima?'
        : 'Ascolta il tutor: le domande inizieranno tra poco!'
      }
      </p>
    </div>
  </div>
}

export default Lecture
