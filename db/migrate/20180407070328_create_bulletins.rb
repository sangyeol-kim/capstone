class CreateBulletins < ActiveRecord::Migration[5.1]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :content
      t.boolean :opt_votable
      t.integer :user_id #게시글 작성자 정보(유저 번호)

      t.timestamps
    end
  end
end
