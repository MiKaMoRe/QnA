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
}

export default Question
