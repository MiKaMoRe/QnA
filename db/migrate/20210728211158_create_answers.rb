class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :question, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_column :questions, :best_answer_id, :bigint
    add_index :questions, :best_answer_id
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
