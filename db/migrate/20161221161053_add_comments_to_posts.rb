class AddCommentsToPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :commentor_id
      t.text :body
      t.boolean :approved
      t.integer :votes
    end
  end
end
