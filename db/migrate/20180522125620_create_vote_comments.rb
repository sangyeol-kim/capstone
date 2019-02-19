class CreateVoteComments < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_comments do |t|
      t.string :mention
      t.timestamps
    end
  end
end
