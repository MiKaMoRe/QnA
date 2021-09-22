import consumer from "./consumer"
import Answer from '../packs/entities/Answer'

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const answer = Answer.jsonRender(data)
    $('.answers').append(answer)
  }
})
