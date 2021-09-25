class Question{
  constructor(){
    this.formEdit()
    this.votingForm()
  }

  formEdit() {
    $('.questions').on('click', '.edit-question-link', e => {
      const questionId = $(e.target).data('questionId')
  
      e.preventDefault();
      $(e.target).hide();
      $('form#edit-question-' + questionId).removeClass('hidden')
    })
  }

  voteLink(id, liked){
    let link = $(`<a class="voting ${liked ? 'upVote' : 'downVote'}">${liked ? 'Like' : 'Dislike'} this</a>`)

    link.attr('data-type', 'json')
    link.attr('data-remote', true)
    link.attr('rel', 'nofollow')
    link.attr('data-method', 'put')
    link.attr('href', `/questions/${id}/vote?liked=${liked}&amp`)
    link.on('ajax:success', e => { this.voteEvent(e) })
    
    return link
  }

  voteCancelLink(id){
    let link = $(`<a class="voting cancelVote"> Cancel my vote</a>`)

    link.attr('data-type', 'json')
    link.attr('data-remote', true)
    link.attr('rel', 'nofollow')
    link.attr('data-method', 'delete')
    link.attr('href', `/questions/${id}/cancel_vote?voteable_type=Question`)
    link.on('ajax:success', e => { this.voteCancelEvent(e) })
    
    return link
  }

  voteEvent(e){
    const vote = e.detail[0]
    const voteCounter = $(`#question-${vote.id} .vote-counter`)
    
    $(`#question-${vote.id} .upVote`).remove()
    $(`#question-${vote.id} .downVote`).replaceWith(this.voteCancelLink(vote.id))
  }

  voteCancelEvent(e){
    const vote = e.detail[0]

    $(`#question-${vote.id} .cancelVote`)
      .replaceWith(this.voteLink(vote.id, true), this.voteLink(vote.id, false))
  }

  voteErrorEvent(e){
    const errors = e.detail[0]

    $('.question-errors').text = ''

    errors.each((index, value) => {
      $('.question-errors').append(`<p>${value}</p>`)
    })
  }

  votingForm() {
    $('.upVote')
      .on('ajax:success', e => { this.voteEvent(e) })
      .on('ajax:error', e => { this.voteErrorEvent(e) })
    $('.downVote')
      .on('ajax:success', e => { this.voteEvent(e) })
      .on('ajax:error', e => { this.voteErrorEvent(e) })
    $('.cancelVote')
      .on('ajax:success', e => { this.voteCancelEvent(e) })
      .on('ajax:error', e => { this.voteErrorEvent(e) })
  }

  static jsonRender(data){
    const locals = JSON.parse(data)

    const question = $('<div></div>').toggleClass('question').attr('id', `question-${locals.question.id}`)
    const voteCounter = $('<h3>0</h3>').toggleClass('vote-counter')
    const votes = $('<div></div>').toggleClass('votes').append(voteCounter)
    const comments = $('<div></div>').toggleClass('comments').append('<h5>Comments: </h5>')
    const newComment = $('<div></div>').toggleClass('new-comment')
    newComment.append(this.newComment(locals))

    question
      .append(`<p>${locals.question.title}</p>`)
      .append(`<p>${locals.question.body}</p>`)
      .append(`<a href="/questions/${locals.question.id}">Open answers</a>`)
      .append(votes)
      .append(comments)
      .append(newComment)

    return question
  }

  static newComment(locals){
    const form = $('<form></form>')
    const token = $('<input></input>')

    form.attr({
      action: `/questions/${locals.question.id}/comments.js`,
      'accept-charset': 'UTF-8',
      'data-remote': true,
      method: 'post'
    })

    token.attr({
      type: 'hide',
      name: 'authenticity_token',
      value: locals.create_comment_token
    }).hide()

    form
      .append(token)
      .append($('<label for="comment_body">Comment:</label>'))
      .append($('<textarea></textarea>').attr({
        name: 'comment[body]',
        id: 'comment_body'
      }))
      .append($('<input></input>').attr({
        type: 'submit',
        name: 'commit',
        value: 'Comment',
        'data-disable-with': 'Comment'
      }))

    return form
  }
}

export default Question
