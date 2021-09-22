import consumer from "./consumer"
import Comment from '../packs/entities/Comment'

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const comment = Comment.jsonRender(data)
    data = JSON.parse(data)
    $(`#${data.resource_name}-${data.resource_id}`).find('.comments').append(comment)
  }
})
