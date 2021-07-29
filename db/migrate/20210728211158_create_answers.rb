class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.reference :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
