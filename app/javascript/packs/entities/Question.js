class Question{
  constructor(){
    this.formEdit()
  }

  formEdit() {
    $('.questions').on('click', '.edit-question-link', e => {
      const questionId = $(e.target).data('questionId')
  
      e.preventDefault();
      $(e.target).hide();
      $('form#edit-question-' + questionId).removeClass('hidden')
    })
  }
}

export default Question
