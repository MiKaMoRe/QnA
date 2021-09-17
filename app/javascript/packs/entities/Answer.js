class Answer{
  constructor(){
    this.formEdit()
    this.bestAnswer()
    this.votingForm()
  }

  formEdit() {
    $('.answers').on('click', '.edit-answer-link', e => {
      const answerId = $(e.target).data('answerId')
  
      e.preventDefault();
      $(e.target).hide();
      $('form#edit-answer-' + answerId).removeClass('hidden')
    })
  }

  bestAnswer() {
    $('.answer').first().before($(".best-answer"))
  }

  voteLink(id, liked){
    let link = $(`<a class="voting ${liked ? 'upVote' : 'downVote'}">${liked ? 'Like' : 'Dislike'} this</a>`)

    link.attr('data-type', 'json')
    link.attr('data-remote', true)
    link.attr('rel', 'nofollow')
    link.attr('data-method', 'put')
    link.attr('href', `/answers/${id}/vote?liked=${liked}&amp`)
    link.on('ajax:success', e => { this.voteEvent(e) })
    
    return link
  }

  voteCancelLink(id){
    let link = $(`<a class="voting cancelVote"> Cancel my vote</a>`)

    link.attr('data-type', 'json')
    link.attr('data-remote', true)
    link.attr('rel', 'nofollow')
    link.attr('data-method', 'delete')
    link.attr('href', `/answers/${id}/cancel_vote?voteable_type=Answer`)
    link.on('ajax:success', e => { this.voteCancelEvent(e) })
    
    return link
  }

  voteEvent(e){
    const vote = e.detail[0]
    const voteCounter = $(`#answer-${vote.id} .vote-counter`)
    
    $(`#answer-${vote.id} .upVote`).remove()
    $(`#answer-${vote.id} .downVote`).replaceWith(this.voteCancelLink(vote.id))
  }

  voteCancelEvent(e){
    const vote = e.detail[0]

    $(`#answer-${vote.id} .cancelVote`)
      .replaceWith(this.voteLink(vote.id, true), this.voteLink(vote.id, false))
  }

  voteErrorEvent(e){
    const errors = e.detail[0]

    $('.answer-errors').text = ''
    
    errors.each((index, value) => {
      $('.answer-errors').append(`<p>${value}</p>`)
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
}

export default Answer
