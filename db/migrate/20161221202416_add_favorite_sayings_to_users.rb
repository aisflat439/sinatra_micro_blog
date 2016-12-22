class AddFavoriteSayingsToUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :sayings do |t|
      t.text :phrase
      t.string :author
    end
  end
end
