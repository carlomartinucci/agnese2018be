let cableEndpoint
if (process.env.NODE_ENV === 'development') {
  cableEndpoint = 'ws://localhost:3000/cable'
} else if (process.env.NODE_ENV === 'production') {
  cableEndpoint = 'wss://agnese2018be.herokuapp.com/cable'
}

export const CABLE_ENDPOINT = cableEndpoint
