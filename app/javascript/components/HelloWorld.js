import React from "react"
import PropTypes from "prop-types"

class HelloWorld extends React.Component {
  render () {
    return (
      <React.Fragment>
        Greeting: {this.props.greetingWord}
      </React.Fragment>
    );
  }
}

HelloWorld.propTypes = {
  greetingWord: PropTypes.string
};

export default HelloWorld
