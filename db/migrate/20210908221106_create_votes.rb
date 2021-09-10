class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :voteable, null: false, polymorphic: true
      t.index [:author_id, :voteable_id], unique: true
      t.boolean :liked

      t.timestamps
    end
  end
end
