class Answer{
  constructor(){
    this.formEdit()
    this.bestAnswer()
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
}

export default Answer
