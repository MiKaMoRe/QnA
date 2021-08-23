class Answer{
  constructor(){
    this.formEdit()
  }

  formEdit() {
    $('.answers').on('click', '.edit-answer-link', e => {
      const answerId = $(e.target).data('answerId')
  
      e.preventDefault();
      $(e.target).hide();
      $('form#edit-answer-' + answerId).removeClass('hidden')
    })
  }
}

export default Answer
