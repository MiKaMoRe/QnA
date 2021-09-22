import consumer from "./consumer"
import Question from '../packs/entities/Question'

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const question = Question.jsonRender(data)
    $('.questions').append(question)
  }
})
